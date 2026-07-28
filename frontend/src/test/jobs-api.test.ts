import { describe, expect, it } from "vitest";
import { normalizeJob, toRecruiterJobPayload, type Job } from "@/lib/jobsApi";

describe("toRecruiterJobPayload", () => {
  it("matches the recruiter job backend request shape", () => {
    const job: Job = {
      id: 12,
      jobId: 34,
      title: "Frontend alias",
      jobTitle: " Frontend Engineer ",
      description: "Description alias",
      jobDescription: " Build UI ",
      jobDescriptionTitle: " Job responsibilities ",
      aboutCompany: " Product team ",
      requirementsTitle: " What you'll bring ",
      requirements: " React\nTypeScript ",
      benefitsTitle: " What we offer ",
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
      requirementDetails: {
        educationMode: "MINIMUM",
        degrees: ["BACHELOR"],
        noDegreeRequirement: "",
        educationMajors: ["Computer Science"],
        preferredInstitutions: [],
        minimumYearsExperience: 3,
        experienceRequirements: ["Built production UIs"],
        requiredSkills: ["Debugging"],
        techStack: ["React", "TypeScript"],
        languageRequired: true,
        languageRequirements: [{
          clientId: "language-local-only",
          languageName: " Japanese ",
          proficiencyLevel: " JLPT N2 ",
          skills: ["Speaking", " Speaking ", "Reading technical documents"],
          certificates: [{
            clientId: "certificate-local-only",
            certificateName: " JLPT ",
            minimumScore: " N2 ",
          }],
        }],
        tools: ["Git"],
        technicalKnowledge: ["REST API"],
      },
    };

    expect(toRecruiterJobPayload(job)).toEqual({
      jobTitle: "Frontend Engineer",
      aboutCompany: "Product team",
      jobDescriptionTitle: "Job responsibilities",
      jobDescription: "Build UI",
      requirementsTitle: "What you'll bring",
      requirements: "React\nTypeScript",
      benefitsTitle: "What we offer",
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
      requirementDetails: {
        educationMode: "MINIMUM",
        degrees: ["BACHELOR"],
        noDegreeRequirement: undefined,
        educationMajors: ["Computer Science"],
        preferredInstitutions: [],
        minimumYearsExperience: 3,
        experienceRequirements: ["Built production UIs"],
        requiredSkills: ["Debugging"],
        techStack: ["React", "TypeScript"],
        languageRequired: true,
        languageRequirements: [{
          languageName: "Japanese",
          proficiencyLevel: "JLPT N2",
          skills: ["Speaking", "Reading technical documents"],
          certificates: [{
            certificateName: "JLPT",
            minimumScore: "N2",
          }],
        }],
        tools: ["Git"],
        technicalKnowledge: ["REST API"],
      },
    });
  });

  it("omits empty benefits instead of sending an empty string", () => {
    expect(toRecruiterJobPayload({ jobTitle: "Backend Engineer", benefits: "" }).benefits).toBeUndefined();
  });

  it("normalizes an English-only legacy response into generic language requirements", () => {
    const normalized = normalizeJob({
      id: 12,
      requirementDetails: {
        educationMode: "NOT_REQUIRED",
        degrees: [],
        educationMajors: [],
        preferredInstitutions: [],
        experienceRequirements: [],
        requiredSkills: [],
        techStack: [],
        englishRequired: true,
        englishLevel: "B2",
        englishSkills: ["Speaking"],
        englishCertificates: [{
          certificateName: "IELTS",
          minimumScore: "6.5",
        }],
        tools: [],
        technicalKnowledge: [],
      },
    });

    expect(normalized.requirementDetails?.languageRequired).toBe(true);
    expect(normalized.requirementDetails?.languageRequirements?.[0]).toEqual(
      expect.objectContaining({
        languageName: "English",
        proficiencyLevel: "Upper-intermediate",
        skills: ["Speaking"],
        certificates: [
          expect.objectContaining({
            certificateName: "IELTS",
            minimumScore: "6.5",
          }),
        ],
      }),
    );
  });
});
