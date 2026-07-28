import { MemoryRouter, Route, Routes } from "react-router-dom";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import PostEditJob from "@/pages/PostEditJob";
import { AI_MATCH_OPTIONS, AI_SCORE_OPTIONS } from "@/lib/jobsApi";

const apiMocks = vi.hoisted(() => ({
  createRecruiterJob: vi.fn(),
  fetchRecommendedCandidateSuggestion: vi.fn(),
  fetchRecommendedCandidates: vi.fn(),
  fetchJob: vi.fn(),
  fetchRecruiter: vi.fn(),
  updateRecruiterJob: vi.fn(),
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

vi.mock("sonner", () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

describe("post job candidate recommendations", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    apiMocks.createRecruiterJob.mockResolvedValue({
      id: 50,
      jobTitle: "Backend Engineer",
    });
    apiMocks.fetchRecruiter.mockResolvedValue({
      id: 9,
      companyDescription: "",
    });
    apiMocks.fetchJob.mockResolvedValue({
      id: 50,
      jobTitle: "Backend Engineer",
      requirementDetails: {
        educationMode: "NOT_REQUIRED",
        degrees: [],
        educationMajors: [],
        preferredInstitutions: [],
        minimumYearsExperience: 3,
        experienceRequirements: ["Built production backend services"],
        requiredSkills: ["Java", "Debugging"],
        techStack: ["Spring Boot", "PostgreSQL"],
        englishRequired: false,
        englishLevel: "",
        englishSkills: [],
        tools: ["Git"],
        technicalKnowledge: ["REST API"],
      },
    });
    apiMocks.updateRecruiterJob.mockResolvedValue({
      id: 50,
      jobTitle: "Senior Backend Engineer",
    });
    apiMocks.fetchRecommendedCandidateSuggestion.mockResolvedValue({
      applicantId: 2,
      jobId: 50,
      matchPercent: 93,
      reason: "Strong Java and Spring Boot experience matches the role.",
      suggestions: ["Discuss system design experience during the interview."],
      perFieldScores: { SKILL: 0.96, EXPERIENCE: 0.88 },
    });
    apiMocks.fetchRecommendedCandidates.mockResolvedValue([
      {
        rank: 1,
        applicant: {
          id: 2,
          fullName: "Nguyen Van An",
          status: "OpenToWork",
          address: "Ho Chi Minh City",
          cv: {
            skills: ["Java", "Spring Boot"],
            experience: { jobTitle: "Backend Developer" },
          },
        },
        match: { matchPercent: 93, matchScore: 0.93 },
      },
      {
        rank: 2,
        applicant: {
          id: 3,
          fullName: "Tran Minh Chau",
          cv: { skills: ["Java", "PostgreSQL"] },
        },
        match: { matchPercent: 81, matchScore: 0.81 },
      },
    ]);
  });

  it("uses the recruiter profile description without showing the company description field", async () => {
    apiMocks.fetchRecruiter.mockResolvedValueOnce({
      id: 9,
      companyDescription: "Profile company overview",
    });

    render(
      <MemoryRouter initialEntries={["/recruiters/jobs/new"]}>
        <Routes>
          <Route path="/recruiters/jobs/new" element={<PostEditJob />} />
        </Routes>
      </MemoryRouter>,
    );

    expect(await screen.findByText(
      "Company overview will be taken automatically from your recruiter profile.",
    )).toBeInTheDocument();
    expect(screen.queryByText("About Company")).not.toBeInTheDocument();
  });

  it("shows a descending candidate ranking immediately after publishing", async () => {
    render(
      <MemoryRouter initialEntries={["/recruiters/jobs/new"]}>
        <Routes>
          <Route path="/recruiters/jobs/new" element={<PostEditJob />} />
        </Routes>
      </MemoryRouter>,
    );

    fireEvent.change(await screen.findByPlaceholderText("Senior Developer"), {
      target: { value: "Backend Engineer" },
    });
    fireEvent.click(screen.getByRole("button", { name: "No degree" }));
    fireEvent.change(screen.getByLabelText("Minimum years of experience *"), {
      target: { value: "3" },
    });
    fireEvent.change(screen.getByLabelText("Expected experience 1"), {
      target: { value: "Built production backend services" },
    });
    fireEvent.click(screen.getByRole("button", { name: "+ Debugging" }));
    fireEvent.click(screen.getByRole("button", { name: "+ React" }));
    fireEvent.click(screen.getByRole("button", { name: "No requirement" }));
    fireEvent.click(screen.getByRole("button", { name: "+ Git" }));
    fireEvent.click(screen.getByRole("button", { name: "Publish Job" }));

    await waitFor(() => expect(apiMocks.createRecruiterJob).toHaveBeenCalled());
    expect(apiMocks.createRecruiterJob).toHaveBeenCalledWith(
      "9",
      expect.objectContaining({
        requirementDetails: expect.objectContaining({
          educationMode: "NOT_REQUIRED",
          degrees: [],
          minimumYearsExperience: 3,
          requiredSkills: ["Debugging"],
          techStack: ["React"],
          englishRequired: false,
          tools: ["Git"],
        }),
      }),
    );
    await waitFor(() => expect(apiMocks.fetchRecommendedCandidates).toHaveBeenCalledWith(
      "9",
      "50",
      10,
      AI_SCORE_OPTIONS,
    ));

    expect(await screen.findByText("Job published successfully")).toBeInTheDocument();
    expect(screen.getByText("Nguyen Van An")).toBeInTheDocument();
    expect(screen.getByText("Tran Minh Chau")).toBeInTheDocument();
    expect(screen.getByText("93% match")).toBeInTheDocument();
    expect(screen.getByText("81% match")).toBeInTheDocument();

    fireEvent.click(screen.getAllByRole("button", { name: "AI Suggestion" })[0]);

    await waitFor(() => expect(apiMocks.fetchRecommendedCandidateSuggestion).toHaveBeenCalledWith(
      "9",
      "50",
      2,
      AI_MATCH_OPTIONS,
    ));
    expect(await screen.findByText("Strong Java and Spring Boot experience matches the role.")).toBeInTheDocument();
    expect(screen.getByText("Skill")).toBeInTheDocument();
    expect(screen.getByText("96%")).toBeInTheDocument();
  });

  it("shows the refreshed ranking after saving job changes", async () => {
    render(
      <MemoryRouter initialEntries={["/recruiters/jobs/50/edit"]}>
        <Routes>
          <Route path="/recruiters/jobs/:id/edit" element={<PostEditJob />} />
        </Routes>
      </MemoryRouter>,
    );

    expect(await screen.findByDisplayValue("Backend Engineer")).toBeInTheDocument();
    fireEvent.change(screen.getByPlaceholderText("Senior Developer"), {
      target: { value: "Senior Backend Engineer" },
    });
    fireEvent.click(screen.getByRole("button", { name: "Save Changes" }));

    await waitFor(() => expect(apiMocks.updateRecruiterJob).toHaveBeenCalled());
    await waitFor(() => expect(apiMocks.fetchRecommendedCandidates).toHaveBeenCalledWith(
      "9",
      "50",
      10,
      AI_SCORE_OPTIONS,
    ));

    expect(await screen.findByText("Job updated successfully")).toBeInTheDocument();
    expect(screen.getByText("Nguyen Van An")).toBeInTheDocument();
    expect(screen.getByText("93% match")).toBeInTheDocument();
  });
});
