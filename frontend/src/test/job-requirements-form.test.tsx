import { useState } from "react";
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { JobRequirementsForm } from "@/components/JobRequirementsForm";
import type { JobRequirementDetails } from "@/lib/jobsApi";

const initialRequirements: JobRequirementDetails = {
  educationMode: "NOT_REQUIRED",
  degrees: [],
  noDegreeRequirement: "Equivalent practical training",
  educationMajors: [],
  preferredInstitutions: [],
  minimumYearsExperience: 0,
  experienceRequirements: ["Entry-level work is accepted"],
  requiredSkills: ["Problem solving"],
  techStack: ["React"],
  languageRequired: undefined,
  languageRequirements: [],
  englishSkills: [],
  englishCertificates: [],
  tools: ["Git"],
  technicalKnowledge: [],
};

function FormHarness() {
  const [value, setValue] = useState(initialRequirements);
  return <JobRequirementsForm value={value} onChange={setValue} />;
}

describe("JobRequirementsForm language requirements", () => {
  it("adds, edits, and removes multiple free-text languages and certificates", () => {
    render(<FormHarness />);

    fireEvent.click(screen.getByRole("button", { name: "Yes, languages required" }));
    fireEvent.change(screen.getByLabelText("Language name *"), {
      target: { value: "Japanese" },
    });
    fireEvent.change(screen.getByLabelText("Required proficiency *"), {
      target: { value: "JLPT N2 or business conversational" },
    });
    fireEvent.click(screen.getByRole("button", { name: "+ Speaking" }));
    fireEvent.click(screen.getByRole("button", { name: "Add certificate" }));
    fireEvent.change(screen.getByLabelText("Japanese certificate name 1"), {
      target: { value: "JLPT" },
    });
    fireEvent.change(screen.getByLabelText("Japanese certificate score 1"), {
      target: { value: "N2" },
    });

    fireEvent.click(screen.getByRole("button", { name: "Add language" }));
    fireEvent.change(screen.getAllByLabelText("Language name *")[1], {
      target: { value: "Spanish" },
    });
    fireEvent.change(screen.getAllByLabelText("Required proficiency *")[1], {
      target: { value: "Professional working proficiency" },
    });
    fireEvent.click(screen.getAllByRole("button", { name: "+ Writing" })[1]);

    expect(screen.getByDisplayValue("Japanese")).toBeInTheDocument();
    expect(screen.getByDisplayValue("Spanish")).toBeInTheDocument();
    expect(screen.getByDisplayValue("JLPT")).toBeInTheDocument();

    fireEvent.click(screen.getByRole("button", { name: "Remove language requirement 1" }));

    expect(screen.queryByDisplayValue("Japanese")).not.toBeInTheDocument();
    expect(screen.getByDisplayValue("Spanish")).toBeInTheDocument();
  });
});
