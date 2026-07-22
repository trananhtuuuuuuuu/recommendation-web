import { MemoryRouter, Route, Routes } from "react-router-dom";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import JobApplicants from "@/pages/JobApplicants";

const apiMocks = vi.hoisted(() => ({
  fetchJob: vi.fn(),
  fetchJobApplicantCount: vi.fn(),
  fetchJobApplicants: vi.fn(),
  matchRecruiterApplicants: vi.fn(),
}));

vi.mock("@/contexts/AuthContext", () => ({
  useAuth: () => ({
    user: { id: "9", userName: "recruiter" },
    role: "RECRUITER",
  }),
}));

vi.mock("@/lib/jobsApi", async () => {
  const actual = await vi.importActual<typeof import("@/lib/jobsApi")>("@/lib/jobsApi");
  return { ...actual, ...apiMocks };
});

describe("recruiter applicant ranking", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    apiMocks.fetchJob.mockResolvedValue({ id: 50, jobTitle: "Backend Engineer", recruiterId: 9 });
    apiMocks.fetchJobApplicantCount.mockResolvedValue({ applicantCount: 2 });
    apiMocks.fetchJobApplicants.mockResolvedValue([
      { applicationId: 101, applicationOrder: 1, applicant: { id: 1, fullName: "Candidate" } },
      { applicationId: 102, applicationOrder: 2, applicant: { id: 2, fullName: "Candidate" } },
    ]);
    apiMocks.matchRecruiterApplicants.mockResolvedValue([
      {
        applicationId: 102,
        applicationOrder: 2,
        applicant: { id: 2, fullName: "Candidate" },
        match: { matchPercent: 91, matchScore: 0.91, reason: "Strong Spring match", perFieldScores: { SKILL: 0.95 } },
      },
      {
        applicationId: 101,
        applicationOrder: 1,
        applicant: { id: 1, fullName: "Candidate" },
        match: { matchPercent: 64, matchScore: 0.64, reason: "Partial skills match", perFieldScores: { SKILL: 0.66 } },
      },
    ]);
  });

  it("uses application ordinals and sorts descending after the real AI match request", async () => {
    render(
      <MemoryRouter initialEntries={["/jobs/50/applicants"]}>
        <Routes><Route path="/jobs/:jobId/applicants" element={<JobApplicants />} /></Routes>
      </MemoryRouter>,
    );

    expect(await screen.findByText("Candidate 1st")).toBeInTheDocument();
    expect(screen.getByText("Candidate 2nd")).toBeInTheDocument();
    expect(screen.queryByText(/Candidate #/)).not.toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "AI Match" }));

    await waitFor(() => expect(apiMocks.matchRecruiterApplicants).toHaveBeenCalledWith(
      "9", "50", { llm: false, method: "tfidf" },
    ));
    expect(await screen.findByText("Rank 1 · 91% match")).toBeInTheDocument();
    expect(screen.getByText("Strong Spring match")).toBeInTheDocument();

    const secondApplicant = screen.getByText("Candidate 2nd").closest("div.glass-card");
    const firstApplicant = screen.getByText("Candidate 1st").closest("div.glass-card");
    expect(secondApplicant?.compareDocumentPosition(firstApplicant as Node) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy();
  });
});
