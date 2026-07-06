import { MemoryRouter, Route, Routes } from "react-router-dom";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import JobDetail from "@/pages/JobDetail";
import { ApiError } from "@/lib/api";
import { AI_MATCH_OPTIONS } from "@/lib/jobsApi";

const authState = vi.hoisted(() => ({
  user: { id: "7", userName: "candidate", email: "candidate@example.com" },
  role: "APPLICANT" as const,
  isAuthenticated: true,
}));

const apiMocks = vi.hoisted(() => ({
  fetchJob: vi.fn(),
  fetchApplicantActivityCount: vi.fn(),
  fetchAnonymousCandidatePreviews: vi.fn(),
  fetchJobApplicantCount: vi.fn(),
  applyJob: vi.fn(),
  matchCvToJob: vi.fn(),
  saveJob: vi.fn(),
  getApplyingDeadline: vi.fn(() => "2026-07-31"),
}));

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => authState,
}));

vi.mock("@/lib/jobsApi", async () => {
  const actual = await vi.importActual<typeof import("@/lib/jobsApi")>("@/lib/jobsApi");
  return {
    ...actual,
    fetchJob: apiMocks.fetchJob,
    fetchApplicantActivityCount: apiMocks.fetchApplicantActivityCount,
    fetchAnonymousCandidatePreviews: apiMocks.fetchAnonymousCandidatePreviews,
    fetchJobApplicantCount: apiMocks.fetchJobApplicantCount,
    applyJob: apiMocks.applyJob,
    matchCvToJob: apiMocks.matchCvToJob,
    saveJob: apiMocks.saveJob,
    getApplyingDeadline: apiMocks.getApplyingDeadline,
  };
});

vi.mock("sonner", () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

const renderJobDetail = () => render(
  <MemoryRouter initialEntries={["/jobs/123"]}>
    <Routes>
      <Route path="/jobs/:id" element={<JobDetail />} />
    </Routes>
  </MemoryRouter>,
);

describe("Job detail applicant privacy", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    apiMocks.fetchJob.mockResolvedValue({
      id: 123,
      jobTitle: "Backend Engineer",
      companyName: "Example Corp",
      location: "Ho Chi Minh City",
      jobType: "Full-time",
      salaryRange: "Negotiable",
    });
    apiMocks.fetchAnonymousCandidatePreviews.mockResolvedValue({
      available: false,
      profiles: [],
    });
  });

  it("shows the applicant-facing approximate count with privacy explanation", async () => {
    apiMocks.fetchApplicantActivityCount.mockResolvedValue({
      jobId: 123,
      approximateApplicantCount: 18,
      displayText: "Approximately 18 candidates have applied",
      approximate: true,
    });

    renderJobDetail();

    expect(await screen.findByText("Approximately 18 candidates have applied")).toBeInTheDocument();
    expect(screen.getByText("This count is intentionally approximate to protect applicant privacy.")).toBeInTheDocument();
    expect(screen.queryByText("18 applicants")).not.toBeInTheDocument();
  });

  it("shows an error and retries the approximate count without exposing an exact fallback", async () => {
    apiMocks.fetchApplicantActivityCount
      .mockRejectedValueOnce(new ApiError("Applicant activity is unavailable right now.", 503))
      .mockResolvedValueOnce({
        jobId: 123,
        approximateApplicantCount: 21,
        displayText: "Approximately 21 candidates have applied",
        approximate: true,
      });

    renderJobDetail();

    expect(await screen.findByText("Applicant activity is unavailable right now.")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Retry" }));

    await waitFor(() => expect(apiMocks.fetchApplicantActivityCount).toHaveBeenCalledTimes(2));
    expect(await screen.findByText("Approximately 21 candidates have applied")).toBeInTheDocument();
  });

  it("runs the AI suggestion from the UI and toggles the result panel", async () => {
    apiMocks.fetchApplicantActivityCount.mockResolvedValue({
      jobId: 123,
      approximateApplicantCount: 18,
      displayText: "Approximately 18 candidates have applied",
      approximate: true,
    });
    apiMocks.matchCvToJob.mockResolvedValue({
      matchPercent: 82,
      passedFilter: true,
      reason: "Strong backend match",
      suggestions: ["Add more Spring Boot project detail"],
      hardFilterReasons: [],
      perFieldScores: {
        SKILL: 0.9,
        EXPERIENCE: 0.75,
      },
    });

    renderJobDetail();

    fireEvent.click(await screen.findByRole("button", { name: /AI Suggestion/i }));

    await waitFor(() => expect(apiMocks.matchCvToJob).toHaveBeenCalledWith(
      "7",
      "123",
      AI_MATCH_OPTIONS,
    ));
    expect(await screen.findByRole("button", { name: /Hide AI/i })).toBeInTheDocument();
    expect(screen.getByText("82%")).toBeInTheDocument();
    expect(screen.getByText("Strong backend match")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: /Hide AI/i }));

    expect(await screen.findByRole("button", { name: /Show AI/i })).toBeInTheDocument();
    await waitFor(() => expect(screen.queryByText("Strong backend match")).not.toBeInTheDocument());

    fireEvent.click(screen.getByRole("button", { name: /Show AI/i }));

    expect(await screen.findByRole("button", { name: /Hide AI/i })).toBeInTheDocument();
    expect(screen.getByText("Strong backend match")).toBeInTheDocument();
  });
});
