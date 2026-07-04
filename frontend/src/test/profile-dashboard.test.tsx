import { MemoryRouter } from "react-router-dom";
import { fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import Profile from "@/pages/Profile";
import SavedJobs from "@/pages/SavedJobs";
import type { Applicant, PageResponse, SavedJob } from "@/lib/jobsApi";

const authState = vi.hoisted(() => ({
  user: { id: "1", userName: "candidate", email: "candidate@example.com" },
  role: "APPLICANT" as const,
}));

const apiMocks = vi.hoisted(() => ({
  fetchApplicant: vi.fn(),
  fetchRecruiter: vi.fn(),
  fetchAppliedJobs: vi.fn(),
  fetchSavedJobs: vi.fn(),
  removeSavedJob: vi.fn(),
  withdrawApplication: vi.fn(),
}));

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => authState,
}));

vi.mock("@/lib/jobsApi", async () => {
  const actual = await vi.importActual<typeof import("@/lib/jobsApi")>("@/lib/jobsApi");
  return {
    ...actual,
    fetchApplicant: apiMocks.fetchApplicant,
    fetchRecruiter: apiMocks.fetchRecruiter,
    fetchAppliedJobs: apiMocks.fetchAppliedJobs,
    fetchSavedJobs: apiMocks.fetchSavedJobs,
    removeSavedJob: apiMocks.removeSavedJob,
    withdrawApplication: apiMocks.withdrawApplication,
  };
});

vi.mock("sonner", () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

const pageOf = (content: SavedJob[], page: number, totalElements = content.length): PageResponse<SavedJob> => ({
  content,
  page,
  size: 5,
  totalElements,
  totalPages: totalElements === 0 ? 0 : Math.ceil(totalElements / 5),
  first: page === 0,
  last: totalElements === 0 || page >= Math.ceil(totalElements / 5) - 1,
});

const applicantWithSkills = (skills: string[]): Applicant => ({
  id: "1",
  userName: "candidate",
  email: "candidate@example.com",
  fullName: "Candidate One",
  cv: {
    skills,
    experience: null,
    education: null,
    certifications: null,
  },
});

const selectTab = (name: string) => {
  const tab = screen.getByRole("tab", { name });
  fireEvent.pointerDown(tab, { button: 0, ctrlKey: false });
  fireEvent.pointerUp(tab, { button: 0, ctrlKey: false });
  fireEvent.click(tab);
};

describe("profile dashboard sections", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("expands and collapses compact skill chips", async () => {
    apiMocks.fetchApplicant.mockResolvedValue(applicantWithSkills([
      "Java",
      "SQL",
      "C++",
      "Spring Boot",
      "PostgreSQL",
      "Hibernate",
      "JWT",
      "React",
      "TypeScript",
      "Docker",
      "Kubernetes",
      "Very Long Skill Name That Should Wrap Without Breaking Layout",
    ]));

    render(<Profile />);

    expect(await screen.findByText("Java")).toBeInTheDocument();
    expect(screen.queryByText("Kubernetes")).not.toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "+2 more" }));
    expect(screen.getByText("Kubernetes")).toBeInTheDocument();
    expect(screen.getByText("Very Long Skill Name That Should Wrap Without Breaking Layout")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Show less" }));
    expect(screen.queryByText("Kubernetes")).not.toBeInTheDocument();
  });
});

describe("saved and applied jobs dashboard", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    apiMocks.fetchAppliedJobs.mockResolvedValue(pageOf([], 0, 0));
    apiMocks.fetchSavedJobs.mockResolvedValue(pageOf([], 0, 0));
  });

  it("switches tabs and preserves empty states with totals", async () => {
    apiMocks.fetchAppliedJobs.mockResolvedValue(pageOf([], 0, 0));
    apiMocks.fetchSavedJobs.mockResolvedValue(pageOf([
      {
        applicantJobId: 10,
        jobDescriptionId: 101,
        jobTitle: "Backend Engineer",
        companyName: "Example Corp",
        location: "Remote",
        jobType: "Full-time",
        savedAt: "2026-07-04",
      },
    ], 0, 12));

    render(<MemoryRouter><SavedJobs /></MemoryRouter>);

    expect(await screen.findByText("No applications submitted yet.")).toBeInTheDocument();
    await waitFor(() => expect(screen.getByRole("tab", { name: "Saved Jobs (12)" })).toBeInTheDocument());

    selectTab("Saved Jobs (12)");
    expect(await screen.findByText("Backend Engineer")).toBeInTheDocument();
    expect(screen.getByText("Full-time")).toBeInTheDocument();
  });

  it("navigates paginated saved jobs", async () => {
    apiMocks.fetchSavedJobs.mockImplementation((_applicantId: string, page: number, size: number) =>
      Promise.resolve(pageOf([
        {
          applicantJobId: page === 0 ? 10 : 20,
          jobDescriptionId: page === 0 ? 101 : 201,
          jobTitle: page === 0 ? "Saved Job One" : "Saved Job Six",
          companyName: "Example Corp",
        },
      ], page, 6)),
    );

    render(<MemoryRouter><SavedJobs /></MemoryRouter>);

    await waitFor(() => expect(screen.getByRole("tab", { name: "Saved Jobs (6)" })).toBeInTheDocument());
    selectTab("Saved Jobs (6)");

    expect(await screen.findByText("Saved Job One")).toBeInTheDocument();
    expect(screen.getByText("Page 1 of 2")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Previous" })).toBeDisabled();

    fireEvent.click(screen.getByRole("button", { name: "Next" }));
    expect(await screen.findByText("Saved Job Six")).toBeInTheDocument();
    expect(screen.getByText("Page 2 of 2")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Next" })).toBeDisabled();
  });

  it("confirms saved-job removal and moves to the previous page when the page becomes empty", async () => {
    let removed = false;
    apiMocks.fetchSavedJobs.mockImplementation((_applicantId: string, page: number, size: number) => {
      if (size === 1) {
        return Promise.resolve(pageOf([{ applicantJobId: 10, jobDescriptionId: 101, jobTitle: "Saved Job One" }], 0, 6));
      }
      if (page === 1) {
        return Promise.resolve(pageOf([{ applicantJobId: 20, jobDescriptionId: 201, jobTitle: "Last Saved Job" }], 1, 6));
      }
      return Promise.resolve(pageOf([{ applicantJobId: 10, jobDescriptionId: 101, jobTitle: "Saved Job One" }], 0, removed ? 5 : 6));
    });
    apiMocks.removeSavedJob.mockImplementation(() => {
      removed = true;
      return Promise.resolve({ applicantJobId: 20 });
    });

    render(<MemoryRouter><SavedJobs /></MemoryRouter>);

    await waitFor(() => expect(screen.getByRole("tab", { name: "Saved Jobs (6)" })).toBeInTheDocument());
    selectTab("Saved Jobs (6)");
    expect(await screen.findByText("Saved Job One")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Next" }));
    const lastJob = await screen.findByText("Last Saved Job");
    const card = lastJob.closest("article");
    expect(card).not.toBeNull();

    fireEvent.click(within(card as HTMLElement).getByRole("button", { name: "Remove Last Saved Job" }));
    fireEvent.click(await screen.findByRole("button", { name: "Remove saved job" }));

    await waitFor(() => expect(apiMocks.removeSavedJob).toHaveBeenCalledWith("1", "20"));
    await waitFor(() => expect(screen.getByText("Saved Job One")).toBeInTheDocument());
    expect(apiMocks.fetchSavedJobs).toHaveBeenLastCalledWith("1", 0, 5);
  });
});
