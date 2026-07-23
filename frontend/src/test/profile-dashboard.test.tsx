import { MemoryRouter } from "react-router-dom";
import { fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import Profile from "@/pages/Profile";
import SavedJobs from "@/pages/SavedJobs";
import type { Applicant, PageResponse, SavedJob } from "@/lib/jobsApi";

const authState = vi.hoisted(() => ({
  user: { id: "1", userName: "candidate", email: "candidate@example.com" },
  role: "APPLICANT" as "APPLICANT" | "RECRUITER",
}));

const apiMocks = vi.hoisted(() => ({
  fetchApplicant: vi.fn(),
  fetchRecruiter: vi.fn(),
  fetchRecruiterJobs: vi.fn(),
  uploadRecruiterImage: vi.fn(),
  fetchAppliedJobs: vi.fn(),
  fetchSavedJobs: vi.fn(),
  removeSavedJob: vi.fn(),
  withdrawApplication: vi.fn(),
  analyzeCv: vi.fn(),
  updateApplicant: vi.fn(),
  updateApplicantPrivacy: vi.fn(),
  uploadCv: vi.fn(),
}));

const toastMocks = vi.hoisted(() => ({
  success: vi.fn(),
  error: vi.fn(),
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
    fetchRecruiterJobs: apiMocks.fetchRecruiterJobs,
    uploadRecruiterImage: apiMocks.uploadRecruiterImage,
    fetchAppliedJobs: apiMocks.fetchAppliedJobs,
    fetchSavedJobs: apiMocks.fetchSavedJobs,
    removeSavedJob: apiMocks.removeSavedJob,
    withdrawApplication: apiMocks.withdrawApplication,
    analyzeCv: apiMocks.analyzeCv,
    updateApplicant: apiMocks.updateApplicant,
    updateApplicantPrivacy: apiMocks.updateApplicantPrivacy,
    uploadCv: apiMocks.uploadCv,
  };
});

vi.mock("sonner", () => ({
  toast: toastMocks,
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
    authState.role = "APPLICANT";
    authState.user = { id: "1", userName: "candidate", email: "candidate@example.com" };
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

  it("validates extracted phone numbers in the editable CV preview before save", async () => {
    apiMocks.fetchApplicant.mockResolvedValue({
      ...applicantWithSkills([]),
      phone: "",
      address: "",
      gender: "Male",
      cv: null,
    });
    apiMocks.analyzeCv.mockResolvedValue({
      fullName: "Extracted Candidate",
      detectedEmail: "extracted@example.com",
      phone: "0916044262Thu",
      address: "Ho Chi Minh City",
      objective: "Become a Java developer",
      skills: ["Java", "Spring Boot"],
      experience: [{
        companyName: "Example Company",
        position: "Java Intern",
        time: "2025",
        description: "Built REST APIs",
        skills: "Java",
        certificates: "",
      }],
      education: ["HCMUS"],
      certifications: ["AWS Cloud Practitioner"],
      extractionMode: "layoutlmv3",
      confidence: 0.89,
      warnings: [],
    });
    apiMocks.updateApplicant.mockResolvedValue(applicantWithSkills(["Java", "Spring Boot"]));
    apiMocks.updateApplicantPrivacy.mockResolvedValue({});
    apiMocks.uploadCv.mockResolvedValue({});

    render(<Profile />);

    expect(await screen.findByText("Candidate One")).toBeInTheDocument();
    fireEvent.click(screen.getAllByRole("button", { name: "Upload CV file" })[0]);

    const cvInput = document.querySelector(
      'input[type="file"][accept*="application/pdf"]',
    ) as HTMLInputElement;
    const cvFile = new File(["cv"], "candidate.pdf", { type: "application/pdf" });
    fireEvent.change(cvInput, { target: { files: [cvFile] } });

    expect(await screen.findByText("CV analysis preview")).toBeInTheDocument();
    expect(screen.getByText("Not saved")).toBeInTheDocument();
    expect(screen.queryByText(/confidence/i)).not.toBeInTheDocument();
    expect(screen.getAllByDisplayValue("Extracted Candidate")).toHaveLength(2);
    expect(screen.getAllByDisplayValue("0916044262Thu")).toHaveLength(2);
    expect(screen.getAllByDisplayValue("Java")).toHaveLength(2);
    expect(screen.getByDisplayValue("Spring Boot")).toBeInTheDocument();
    expect(screen.getByDisplayValue("Example Company")).toBeInTheDocument();
    expect(screen.getByDisplayValue("HCMUS")).toBeInTheDocument();
    expect(screen.getAllByText("Phone number contains invalid characters.")).toHaveLength(2);
    expect(screen.getByLabelText("Phone")).toHaveAttribute("aria-invalid", "true");
    expect(screen.getByLabelText("CV Phone")).toHaveAttribute("aria-invalid", "true");
    expect(apiMocks.updateApplicant).not.toHaveBeenCalled();
    expect(apiMocks.uploadCv).not.toHaveBeenCalled();
    expect(toastMocks.error).not.toHaveBeenCalled();

    fireEvent.click(screen.getByRole("button", { name: "Save" }));

    expect(apiMocks.updateApplicant).not.toHaveBeenCalled();
    expect(apiMocks.uploadCv).not.toHaveBeenCalled();
    expect(toastMocks.error).toHaveBeenCalledWith("Phone number contains invalid characters.");
    expect(screen.getByText("CV analysis preview")).toBeInTheDocument();

    fireEvent.change(screen.getByLabelText("Phone"), { target: { value: "+84 916-044-262" } });
    fireEvent.change(screen.getByLabelText("CV Phone"), { target: { value: "VN (+84) 916-044-262" } });
    fireEvent.change(screen.getByLabelText("Email"), { target: { value: "" } });
    fireEvent.click(screen.getByRole("button", { name: "Clear gender" }));

    expect(screen.queryByText("Phone number contains invalid characters.")).not.toBeInTheDocument();
    expect(screen.getByLabelText("Phone")).toHaveAttribute("aria-invalid", "false");
    expect(screen.getByLabelText("CV Phone")).toHaveAttribute("aria-invalid", "false");

    fireEvent.click(screen.getByRole("button", { name: "Save" }));

    await waitFor(() => expect(apiMocks.updateApplicant).toHaveBeenCalledWith(
      "1",
      expect.objectContaining({ email: "", gender: "" }),
    ));
    expect(apiMocks.uploadCv).toHaveBeenCalled();
  });

  it("keeps only the Posts content tab and uploads logo and cover separately", async () => {
    authState.role = "RECRUITER";
    authState.user = { id: "9", userName: "recruiter", email: "recruiter@example.com" };
    apiMocks.fetchRecruiter.mockResolvedValue({ id: 9, companyName: "Example Corp" });
    apiMocks.fetchRecruiterJobs.mockResolvedValue([{ id: 50, jobTitle: "Backend Engineer" }]);
    apiMocks.uploadRecruiterImage.mockResolvedValue({
      id: 9,
      companyName: "Example Corp",
      logoUrl: "/uploads/recruiters/9/logo.png",
    });

    render(<Profile />);

    expect(await screen.findByRole("tab", { name: "posts" })).toBeInTheDocument();
    expect(screen.queryByRole("tab", { name: "jobs" })).not.toBeInTheDocument();
    expect(screen.getByText("Upload Logo")).toBeInTheDocument();
    expect(screen.getByText("Upload Cover image")).toBeInTheDocument();

    const logoInput = document.getElementById("recruiter-logo-upload") as HTMLInputElement;
    const logo = new File(["logo"], "logo.png", { type: "image/png" });
    fireEvent.change(logoInput, { target: { files: [logo] } });

    await waitFor(() => expect(apiMocks.uploadRecruiterImage).toHaveBeenCalledWith("9", "logo", logo));
    expect(await screen.findByText("Replace Logo")).toBeInTheDocument();
  });
});

describe("saved and applied jobs dashboard", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    authState.role = "APPLICANT";
    authState.user = { id: "1", userName: "candidate", email: "candidate@example.com" };
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
