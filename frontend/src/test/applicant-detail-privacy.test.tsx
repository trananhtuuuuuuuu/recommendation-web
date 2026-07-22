import { MemoryRouter, Route, Routes } from "react-router-dom";
import { render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import ApplicantDetail from "@/pages/ApplicantDetail";

const apiMocks = vi.hoisted(() => ({
  fetchApplicant: vi.fn(),
}));

vi.mock("@/lib/jobsApi", async () => {
  const actual = await vi.importActual<typeof import("@/lib/jobsApi")>("@/lib/jobsApi");
  return { ...actual, fetchApplicant: apiMocks.fetchApplicant };
});

describe("recruiter-visible applicant profile", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    apiMocks.fetchApplicant.mockResolvedValue({
      id: 12,
      fullName: "Tran Anh Tu",
      email: "tran@example.com",
      phone: "+84901234567",
      address: "Ho Chi Minh City",
      cv: {
        experience: { field: "Data Engineering", jobTitle: "Backend Engineer" },
      },
    });
  });

  it("renders only the profile fields returned by the privacy-filtered API", async () => {
    render(
      <MemoryRouter initialEntries={["/applicants/12"]}>
        <Routes><Route path="/applicants/:id" element={<ApplicantDetail />} /></Routes>
      </MemoryRouter>,
    );

    expect(await screen.findAllByText("Tran Anh Tu")).not.toHaveLength(0);
    expect(screen.getAllByText("tran@example.com")).not.toHaveLength(0);
    expect(screen.getAllByText("+84901234567")).not.toHaveLength(0);
    expect(screen.getAllByText("Ho Chi Minh City")).not.toHaveLength(0);
    expect(screen.getByText("Data Engineering")).toBeInTheDocument();
    expect(screen.queryByText(/Candidate #/)).not.toBeInTheDocument();
  });
});
