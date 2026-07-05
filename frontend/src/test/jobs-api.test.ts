import { describe, expect, it } from "vitest";
import { toRecruiterJobPayload, type Job } from "@/lib/jobsApi";

describe("toRecruiterJobPayload", () => {
  it("matches the recruiter job backend request shape", () => {
    const job: Job = {
      id: 12,
      jobId: 34,
      title: "Frontend alias",
      jobTitle: " Frontend Engineer ",
      description: "Description alias",
      jobDescription: " Build UI ",
      aboutCompany: " Product team ",
      requirements: " React\nTypeScript ",
      benefits: "Health insurance\nLearning budget,, Remote work",
      location: " Remote ",
      salaryRange: " ",
      jobType: "Full-time",
      yoe: "3+ years",
      experienceLevel: " Senior ",
      industry: " Software ",
      startDate: "2026-09-01",
      endDate: "2027-09-01",
      postedDate: "",
      applicationDeadline: "2026-08-01",
      companyName: "Example Corp",
      customApplicationFields: "[]",
    };

    expect(toRecruiterJobPayload(job)).toEqual({
      jobTitle: "Frontend Engineer",
      aboutCompany: "Product team",
      jobDescription: "Build UI",
      requirements: "React\nTypeScript",
      benefits: ["Health insurance", "Learning budget", "Remote work"],
      location: "Remote",
      salaryRange: undefined,
      jobType: "Full-time",
      postedDate: undefined,
      applyingDeadline: "2026-08-01",
      yoe: "3+ years",
      customApplicationFieldsId: undefined,
      experienceLevel: "Senior",
      industry: "Software",
      startDate: "2026-09-01",
      endDate: "2027-09-01",
      customApplicationFields: "[]",
    });
  });

  it("omits empty benefits instead of sending an empty string", () => {
    expect(toRecruiterJobPayload({ jobTitle: "Backend Engineer", benefits: "" }).benefits).toBeUndefined();
  });
});
