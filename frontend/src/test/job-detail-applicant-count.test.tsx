import { MemoryRouter, Route, Routes } from "react-router-dom";
import { act, fireEvent, render, screen, waitFor } from "@testing-library/react";
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
  fetchApplicantCountRelease: vi.fn(),
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
    fetchApplicantCountRelease: apiMocks.fetchApplicantCountRelease,
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

describe("Job detail applicant-count privacy releases", () => {
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

  it("shows only the released count without DP or refresh explanations", async () => {
    apiMocks.fetchApplicantCountRelease.mockResolvedValue({
      jobId: 123,
      applicantCount: 18,
      displayText: "18 candidates have applied",
      snapshotCapturedAt: "2026-07-28T10:15:00Z",
      nextRefreshAt: "2026-07-28T22:00:00Z",
      refreshIntervalHours: 12,
    });

    renderJobDetail();

    expect(await screen.findByText("18 candidates have applied")).toBeInTheDocument();
    expect(screen.queryByText(/Updated every|Next update/i)).not.toBeInTheDocument();
    expect(screen.queryByText(/approximate|differential privacy|noise|epsilon/i)).not.toBeInTheDocument();
    expect(screen.queryByText("18 applicants")).not.toBeInTheDocument();
  });

  it("shows an error and retries the snapshot without using the recruiter exact endpoint", async () => {
    apiMocks.fetchApplicantCountRelease
      .mockRejectedValueOnce(new ApiError("Applicant activity is unavailable right now.", 503))
      .mockResolvedValueOnce({
        jobId: 123,
        applicantCount: 21,
        displayText: "21 candidates have applied",
        snapshotCapturedAt: "2026-07-28T10:15:00Z",
        nextRefreshAt: "2026-07-28T22:00:00Z",
        refreshIntervalHours: 12,
      });

    renderJobDetail();

    expect(await screen.findByText("Applicant activity is unavailable right now.")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Retry" }));

    await waitFor(() => expect(apiMocks.fetchApplicantCountRelease).toHaveBeenCalledTimes(2));
    expect(await screen.findByText("21 candidates have applied")).toBeInTheDocument();
    expect(apiMocks.fetchJobApplicantCount).not.toHaveBeenCalled();
  });

  it("runs the AI suggestion from the UI and toggles the result panel", async () => {
    apiMocks.fetchApplicantCountRelease.mockResolvedValue({
      jobId: 123,
      applicantCount: 18,
      displayText: "18 candidates have applied",
      snapshotCapturedAt: "2026-07-28T10:15:00Z",
      nextRefreshAt: "2026-07-28T22:00:00Z",
      refreshIntervalHours: 12,
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

  it("renders structured recruiter requirements by CV section", async () => {
    apiMocks.fetchApplicantCountRelease.mockResolvedValue({
      jobId: 123,
      applicantCount: 18,
      displayText: "18 candidates have applied",
      snapshotCapturedAt: "2026-07-28T10:15:00Z",
      nextRefreshAt: "2026-07-28T22:00:00Z",
      refreshIntervalHours: 12,
    });
    apiMocks.fetchJob.mockResolvedValue({
      id: 123,
      jobTitle: "Backend Engineer",
      jobDescriptionTitle: "Job responsibilities",
      jobDescription: "Build APIs\nReview pull requests",
      requirementsTitle: "What you'll bring",
      requirementDetails: {
        educationMode: "ANY_OF",
        degrees: ["BACHELOR", "MASTER"],
        educationMajors: ["Computer Science"],
        preferredInstitutions: ["HCMUS"],
        minimumYearsExperience: 0,
        experienceRequirements: ["Built production REST APIs"],
        requiredSkills: ["Java", "Debugging"],
        techStack: ["Spring Boot", "PostgreSQL"],
        languageRequired: true,
        languageRequirements: [
          {
            languageName: "Japanese",
            proficiencyLevel: "JLPT N2 or business conversational",
            skills: ["Speaking", "Reading technical documents"],
            certificates: [{
              certificateName: "JLPT",
              minimumScore: "N2",
            }],
          },
          {
            languageName: "Spanish",
            proficiencyLevel: "Professional working proficiency",
            skills: ["Speaking", "Writing"],
            certificates: [],
          },
        ],
        englishRequired: false,
        englishSkills: [],
        englishCertificates: [],
        tools: ["Git", "Postman"],
        technicalKnowledge: ["System design"],
      },
    });

    renderJobDetail();

    expect(await screen.findByText("What you'll bring")).toBeInTheDocument();
    expect(screen.queryByText("Matching requirements")).not.toBeInTheDocument();
    expect(screen.getByText("Job responsibilities")).toBeInTheDocument();
    expect(screen.getByText("Build APIs")).toBeInTheDocument();
    expect(screen.getByText("Relevant majors:", { exact: false })).toHaveTextContent("Computer Science");
    expect(screen.getByText("Built production REST APIs")).toBeInTheDocument();
    expect(screen.getByText("No experience required")).toBeInTheDocument();
    expect(screen.getByText("Tech stack:", { exact: false })).toHaveTextContent("Spring Boot");
    expect(screen.getByText("Japanese:", { exact: false }))
      .toHaveTextContent("JLPT N2 or business conversational");
    expect(screen.getByText("Japanese certificate:", { exact: false }))
      .toHaveTextContent("JLPT — N2");
    expect(screen.getByText("Spanish:", { exact: false }))
      .toHaveTextContent("Professional working proficiency");
    expect(screen.getByText("Tools:", { exact: false })).toHaveTextContent("Git, Postman");
  });

  it("refetches the snapshot when the current 12-hour window ends", async () => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-07-28T10:00:00Z"));
    apiMocks.fetchApplicantCountRelease
      .mockResolvedValueOnce({
        jobId: 123,
        applicantCount: 18,
        displayText: "18 candidates have applied",
        snapshotCapturedAt: "2026-07-28T09:00:00Z",
        nextRefreshAt: "2026-07-28T10:00:01Z",
        refreshIntervalHours: 12,
      })
      .mockResolvedValueOnce({
        jobId: 123,
        applicantCount: 20,
        displayText: "20 candidates have applied",
        snapshotCapturedAt: "2026-07-28T10:00:01Z",
        nextRefreshAt: "2026-07-28T22:00:01Z",
        refreshIntervalHours: 12,
      });

    const view = renderJobDetail();
    try {
      await act(async () => {
        await Promise.resolve();
        await Promise.resolve();
      });
      expect(apiMocks.fetchApplicantCountRelease).toHaveBeenCalledTimes(1);

      await act(async () => {
        await vi.advanceTimersByTimeAsync(1_250);
      });

      expect(apiMocks.fetchApplicantCountRelease).toHaveBeenCalledTimes(2);
      expect(screen.getByText("20 candidates have applied")).toBeInTheDocument();
    } finally {
      view.unmount();
      vi.useRealTimers();
    }
  });
});
