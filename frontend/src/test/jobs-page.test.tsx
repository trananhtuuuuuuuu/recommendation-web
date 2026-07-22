import { MemoryRouter } from "react-router-dom";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import Jobs from "@/pages/Jobs";
import { AI_MATCH_OPTIONS, type Job, type PageResponse } from "@/lib/jobsApi";

const authState = vi.hoisted(() => ({
  user: { id: "1", userName: "candidate", email: "candidate@example.com" },
  role: "APPLICANT" as const,
  isAuthenticated: true,
}));

const apiMocks = vi.hoisted(() => ({
  fetchJobsPage: vi.fn(),
  saveJob: vi.fn(),
  matchCvToJob: vi.fn(),
}));

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => authState,
}));

vi.mock("@/lib/jobsApi", async () => {
  const actual = await vi.importActual<typeof import("@/lib/jobsApi")>("@/lib/jobsApi");
  return {
    ...actual,
    fetchJobsPage: apiMocks.fetchJobsPage,
    saveJob: apiMocks.saveJob,
    matchCvToJob: apiMocks.matchCvToJob,
  };
});

vi.mock("sonner", () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

const pageOf = (content: Job[], page: number, totalElements = content.length): PageResponse<Job> => ({
  content,
  page,
  size: 10,
  totalElements,
  totalPages: totalElements === 0 ? 0 : Math.ceil(totalElements / 10),
  first: page === 0,
  last: totalElements === 0 || page >= Math.ceil(totalElements / 10) - 1,
});

describe("Jobs page pagination", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("requests 10 jobs by default and fetches the next server page", async () => {
    apiMocks.fetchJobsPage.mockImplementation((page: number) =>
      Promise.resolve(pageOf([
        {
          id: page === 0 ? 1 : 11,
          jobTitle: page === 0 ? "Backend Engineer" : "Frontend Engineer",
          companyName: "Example Corp",
          location: "Remote",
          jobType: "Full-time",
        },
      ], page, 12)),
    );

    render(<MemoryRouter><Jobs /></MemoryRouter>);

    expect(await screen.findByText("Backend Engineer")).toBeInTheDocument();
    expect(apiMocks.fetchJobsPage).toHaveBeenCalledWith(0, 10);
    expect(screen.getByText("Page 1 of 2")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Next" }));

    await waitFor(() => expect(apiMocks.fetchJobsPage).toHaveBeenCalledWith(1, 10));
    expect(await screen.findByText("Frontend Engineer")).toBeInTheDocument();
    expect(screen.getByText("Page 2 of 2")).toBeInTheDocument();
  });

  it("calls the same AI match API options from the job card suggestion button", async () => {
    apiMocks.fetchJobsPage.mockResolvedValue(pageOf([
      {
        id: 1,
        jobTitle: "Backend Engineer",
        companyName: "Example Corp",
        location: "Remote",
        jobType: "Full-time",
      },
    ], 0));
    apiMocks.matchCvToJob.mockResolvedValue({
      matchPercent: 77,
      passedFilter: true,
      reason: "Backend response from AI match service",
      suggestions: ["Add one more production API example"],
      hardFilterReasons: [],
    });

    render(<MemoryRouter><Jobs /></MemoryRouter>);

    fireEvent.click(await screen.findByRole("button", { name: "AI Suggestion" }));

    await waitFor(() => expect(apiMocks.matchCvToJob).toHaveBeenCalledWith(
      "1",
      "1",
      AI_MATCH_OPTIONS,
    ));
    expect(await screen.findByText("77% Match")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Hide AI/i })).toBeInTheDocument();
  });

  it("keeps AI suggestions expanded independently for multiple jobs", async () => {
    apiMocks.fetchJobsPage.mockResolvedValue(pageOf([
      { id: 1, jobTitle: "Backend Engineer" },
      { id: 2, jobTitle: "Frontend Engineer" },
    ], 0));
    apiMocks.matchCvToJob.mockImplementation((_applicantId: string, jobId: string) => Promise.resolve({
      matchPercent: jobId === "1" ? 81 : 72,
      passedFilter: true,
      reason: jobId === "1" ? "Backend match reason" : "Frontend match reason",
      suggestions: [],
      hardFilterReasons: [],
    }));

    render(<MemoryRouter><Jobs /></MemoryRouter>);

    const suggestionButtons = await screen.findAllByRole("button", { name: "AI Suggestion" });
    fireEvent.click(suggestionButtons[0]);
    expect(await screen.findByText("Backend match reason")).toBeInTheDocument();

    fireEvent.click(suggestionButtons[1]);
    expect(await screen.findByText("Frontend match reason")).toBeInTheDocument();
    expect(screen.getByText("Backend match reason")).toBeInTheDocument();
    expect(screen.getAllByRole("button", { name: /Hide AI/i })).toHaveLength(2);
  });
});
