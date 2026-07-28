import { useId, useState, type KeyboardEvent, type ReactNode } from "react";
import type { LucideIcon } from "lucide-react";
import {
  CheckCircle2,
  Code2,
  GraduationCap,
  Languages,
  Plus,
  Wrench,
  X,
} from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";
import type {
  JobDegree,
  JobRequirementDetails,
  LanguageCertificateRequirement,
  LanguageRequirement,
} from "@/lib/jobsApi";
import { createRequirementClientId } from "@/lib/jobsApi";

const LANGUAGE_SKILL_SUGGESTIONS = ["Speaking", "Listening", "Reading", "Writing"];
const DEGREES: Array<[JobDegree, string]> = [
  ["BACHELOR", "Bachelor"],
  ["MASTER", "Master"],
  ["PHD", "PhD"],
];

type RequirementErrors = Record<string, string>;

interface JobRequirementsFormProps {
  value: JobRequirementDetails;
  onChange: (value: JobRequirementDetails) => void;
  errors?: RequirementErrors;
}

export function JobRequirementsForm({
  value,
  onChange,
  errors = {},
}: JobRequirementsFormProps) {
  const update = <K extends keyof JobRequirementDetails>(
    key: K,
    nextValue: JobRequirementDetails[K],
  ) => onChange({ ...value, [key]: nextValue });

  const languageRequirements = value.languageRequirements ?? [];

  const newLanguageRequirement = (): LanguageRequirement => ({
    clientId: createRequirementClientId("language"),
    languageName: "",
    proficiencyLevel: "",
    skills: [],
    certificates: [],
  });

  const updateLanguage = (index: number, patch: Partial<LanguageRequirement>) => {
    update("languageRequirements", languageRequirements.map((language, itemIndex) =>
      itemIndex === index ? { ...language, ...patch } : language));
  };

  const toggleDegree = (degree: JobDegree) => {
    if (value.educationMode === "MINIMUM") {
      update("degrees", [degree]);
      return;
    }
    const selected = value.degrees.includes(degree);
    update("degrees", selected
      ? value.degrees.filter((item) => item !== degree)
      : [...value.degrees, degree]);
  };

  const completedSections = [
    Boolean(value.educationMode)
      && (value.educationMode === "NOT_REQUIRED"
        ? Boolean(value.noDegreeRequirement?.trim())
        : value.degrees.length > 0 && value.educationMajors.length > 0),
    value.minimumYearsExperience !== undefined
      && value.experienceRequirements.some((item) => item.trim())
      && value.requiredSkills.length > 0
      && value.techStack.length > 0,
    value.languageRequired === false
      || (value.languageRequired === true
        && languageRequirements.length > 0
        && languageRequirements.every((language) =>
          language.languageName.trim()
          && language.proficiencyLevel.trim()
          && language.skills.length > 0
          && language.certificates.every(
            (certificate) => certificate.certificateName.trim()
              && certificate.minimumScore.trim(),
          ))),
    value.tools.length > 0 || value.technicalKnowledge.length > 0,
  ].filter(Boolean).length;

  return (
    <section className="space-y-4" aria-labelledby="job-requirements-title">
      <div className="flex flex-col gap-3 rounded-xl border border-primary/20 bg-primary/5 p-5 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 id="job-requirements-title" className="font-display text-xl font-semibold text-foreground">
            Job requirements
          </h2>
          <p className="mt-1 max-w-3xl text-sm leading-6 text-muted-foreground">
            Add each requirement to the right CV section so the matching system can explain
            education, experience, skills, language, and technical contributions separately.
          </p>
        </div>
        <Badge variant="secondary" className="w-fit gap-1.5 whitespace-nowrap px-3 py-1.5">
          <CheckCircle2 className="h-3.5 w-3.5" />
          {completedSections}/4 sections ready
        </Badge>
      </div>

      <div className="grid gap-4 xl:grid-cols-2">
        <RequirementCard
          icon={GraduationCap}
          title="Education"
          description="Accept several degrees, set one minimum degree, or choose no degree requirement."
        >
          <div className="space-y-2">
            <Label>Degree rule *</Label>
            <div className="grid gap-2 sm:grid-cols-3">
              <ChoiceButton
                selected={value.educationMode === "NOT_REQUIRED"}
                onClick={() => onChange({
                  ...value,
                  educationMode: "NOT_REQUIRED",
                  degrees: [],
                  noDegreeRequirement: value.noDegreeRequirement ?? "",
                  educationMajors: [],
                  preferredInstitutions: [],
                })}
              >
                No degree
              </ChoiceButton>
              <ChoiceButton
                selected={value.educationMode === "ANY_OF"}
                onClick={() => onChange({
                  ...value,
                  educationMode: "ANY_OF",
                  degrees: value.degrees,
                })}
              >
                Any selected
              </ChoiceButton>
              <ChoiceButton
                selected={value.educationMode === "MINIMUM"}
                onClick={() => onChange({
                  ...value,
                  educationMode: "MINIMUM",
                  degrees: value.degrees.slice(0, 1),
                })}
              >
                Minimum degree
              </ChoiceButton>
            </div>
            <FieldError message={errors["requirementDetails.educationMode"]} />
          </div>

          {value.educationMode === "NOT_REQUIRED" ? (
            <div className="space-y-2">
              <Label htmlFor="no-degree-requirement">Applicant expectation without a degree *</Label>
              <Input
                id="no-degree-requirement"
                value={value.noDegreeRequirement ?? ""}
                onChange={(event) => update("noDegreeRequirement", event.target.value)}
                placeholder="e.g. Currently studying or has equivalent professional training"
                aria-invalid={Boolean(errors["requirementDetails.noDegreeRequirement"])}
              />
              <p className="text-xs text-muted-foreground">
                Describe the study status, equivalent training, or practical background you accept.
              </p>
              <FieldError message={errors["requirementDetails.noDegreeRequirement"]} />
            </div>
          ) : null}

          {value.educationMode && value.educationMode !== "NOT_REQUIRED" ? (
            <>
              <div className="space-y-2">
                <Label>Degrees *</Label>
                <div className="grid grid-cols-3 gap-2">
                  {DEGREES.map(([degree, label]) => (
                    <ChoiceButton
                      key={degree}
                      selected={value.degrees.includes(degree)}
                      onClick={() => toggleDegree(degree)}
                      compact
                    >
                      {label}
                    </ChoiceButton>
                  ))}
                </div>
                <p className="text-xs text-muted-foreground">
                  {value.educationMode === "MINIMUM"
                    ? "Choose one degree as the minimum accepted level."
                    : "Choose every degree that is accepted for this role."}
                </p>
                <FieldError message={errors["requirementDetails.degrees"]} />
              </div>
              <TagInput
                label="Relevant majors *"
                values={value.educationMajors}
                onChange={(items) => update("educationMajors", items)}
                placeholder="e.g. Computer Science"
                suggestions={["Computer Science", "Software Engineering", "Information Technology"]}
                error={errors["requirementDetails.educationMajors"]}
              />
              <TagInput
                label="Preferred institutions"
                hint="Optional — leave empty when any institute is accepted."
                values={value.preferredInstitutions}
                onChange={(items) => update("preferredInstitutions", items)}
                placeholder="e.g. HCMUS"
                error={errors["requirementDetails.preferredInstitutions"]}
              />
            </>
          ) : null}
        </RequirementCard>

        <RequirementCard
          icon={Code2}
          title="Experience, skills & stack"
          description="Describe the work evidence you expect, then list skills and technologies separately."
        >
          <div className="space-y-2">
            <Label htmlFor="minimum-years-experience">Minimum years of experience *</Label>
            <Input
              id="minimum-years-experience"
              type="number"
              min={0}
              step={1}
              value={value.minimumYearsExperience ?? ""}
              onChange={(event) => update(
                "minimumYearsExperience",
                event.target.value === "" ? undefined : Number(event.target.value),
              )}
              placeholder="e.g. 3"
            />
            <FieldError message={errors["requirementDetails.minimumYearsExperience"]} />
          </div>

          <StatementListInput
            label="Expected experience *"
            values={value.experienceRequirements}
            onChange={(items) => update("experienceRequirements", items)}
            placeholder="e.g. Built and deployed production REST APIs"
            error={errors["requirementDetails.experienceRequirements"]}
          />

          <TagInput
            label="Required skills *"
            values={value.requiredSkills}
            onChange={(items) => update("requiredSkills", items)}
            placeholder="e.g. Java"
            suggestions={["Debugging", "Problem solving", "System design"]}
            error={errors["requirementDetails.requiredSkills"]}
          />

          <TagInput
            label="Tech stack *"
            values={value.techStack}
            onChange={(items) => update("techStack", items)}
            placeholder="e.g. Spring Boot"
            suggestions={["React", "TypeScript", "PostgreSQL", "Docker"]}
            error={errors["requirementDetails.techStack"]}
          />
        </RequirementCard>

        <RequirementCard
          icon={Languages}
          title="Language requirements"
          description="Add every language needed for the role using recruiter-defined proficiency, skills, and certificates."
        >
          <div className="space-y-2">
            <Label>Are languages required? *</Label>
            <div className="grid grid-cols-2 gap-2">
              <ChoiceButton
                selected={value.languageRequired === true}
                onClick={() => onChange({
                  ...value,
                  languageRequired: true,
                  languageRequirements: languageRequirements.length > 0
                    ? languageRequirements
                    : [newLanguageRequirement()],
                })}
              >
                Yes, languages required
              </ChoiceButton>
              <ChoiceButton
                selected={value.languageRequired === false}
                onClick={() => onChange({
                  ...value,
                  languageRequired: false,
                  languageRequirements: [],
                })}
              >
                No language requirement
              </ChoiceButton>
            </div>
            <FieldError message={errors["requirementDetails.languageRequired"]} />
          </div>

          {value.languageRequired === true ? (
            <div className="space-y-4">
              {languageRequirements.map((language, index) => (
                <div
                  key={language.clientId ?? `${language.languageName}-${index}`}
                  className="space-y-4 rounded-xl border bg-secondary/10 p-4"
                  aria-label={`Language requirement ${index + 1}`}
                >
                  <div className="flex items-center justify-between gap-3">
                    <p className="text-sm font-medium">Language {index + 1}</p>
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="gap-1 text-muted-foreground"
                      onClick={() => update(
                        "languageRequirements",
                        languageRequirements.filter((_, itemIndex) => itemIndex !== index),
                      )}
                      aria-label={`Remove language requirement ${index + 1}`}
                    >
                      <X className="h-4 w-4" />
                      Remove
                    </Button>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor={`language-name-${language.clientId ?? index}`}>
                      Language name *
                    </Label>
                    <Input
                      id={`language-name-${language.clientId ?? index}`}
                      value={language.languageName}
                      onChange={(event) => updateLanguage(index, {
                        languageName: event.target.value,
                      })}
                      placeholder="e.g. Japanese, Spanish, Korean"
                      aria-invalid={Boolean(
                        errors[`requirementDetails.languageRequirements.${index}.languageName`],
                      )}
                    />
                    <FieldError
                      message={errors[
                        `requirementDetails.languageRequirements.${index}.languageName`
                      ]}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor={`language-proficiency-${language.clientId ?? index}`}>
                      Required proficiency *
                    </Label>
                    <Input
                      id={`language-proficiency-${language.clientId ?? index}`}
                      value={language.proficiencyLevel}
                      onChange={(event) => updateLanguage(index, {
                        proficiencyLevel: event.target.value,
                      })}
                      placeholder="e.g. JLPT N2 or business conversational"
                      aria-invalid={Boolean(
                        errors[`requirementDetails.languageRequirements.${index}.proficiencyLevel`],
                      )}
                    />
                    <FieldError
                      message={errors[
                        `requirementDetails.languageRequirements.${index}.proficiencyLevel`
                      ]}
                    />
                  </div>

                  <TagInput
                    label="Required skills *"
                    hint="Type any skill, or use an optional suggestion."
                    values={language.skills}
                    onChange={(skills) => updateLanguage(index, { skills })}
                    placeholder="e.g. Reading technical documents"
                    suggestions={LANGUAGE_SKILL_SUGGESTIONS}
                    error={errors[`requirementDetails.languageRequirements.${index}.skills`]}
                  />

                  <LanguageCertificateInputs
                    languageLabel={language.languageName || `Language ${index + 1}`}
                    values={language.certificates}
                    onChange={(certificates) => updateLanguage(index, { certificates })}
                    error={errors[
                      `requirementDetails.languageRequirements.${index}.certificates`
                    ]}
                  />
                </div>
              ))}
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="gap-2"
                onClick={() => update(
                  "languageRequirements",
                  [...languageRequirements, newLanguageRequirement()],
                )}
              >
                <Plus className="h-4 w-4" />
                Add language
              </Button>
              <FieldError message={errors["requirementDetails.languageRequirements"]} />
            </div>
          ) : null}
        </RequirementCard>

        <RequirementCard
          icon={Wrench}
          title="Tools & technical knowledge"
          description="Separate day-to-day tools from concepts or engineering practices."
        >
          <TagInput
            label="Tools"
            values={value.tools}
            onChange={(items) => update("tools", items)}
            placeholder="e.g. Git"
            suggestions={["Git", "Jira", "Postman", "Figma"]}
            error={errors["requirementDetails.tools"]}
          />
          <TagInput
            label="Technical knowledge"
            values={value.technicalKnowledge}
            onChange={(items) => update("technicalKnowledge", items)}
            placeholder="e.g. REST API"
            suggestions={["CI/CD", "Microservices", "Cloud", "System design"]}
            error={errors["requirementDetails.technicalKnowledge"]}
          />
          <FieldError message={errors["requirementDetails.toolsOrTechnicalKnowledge"]} />
        </RequirementCard>
      </div>
    </section>
  );
}

function RequirementCard({
  icon: Icon,
  title,
  description,
  children,
}: {
  icon: LucideIcon;
  title: string;
  description: string;
  children: ReactNode;
}) {
  return (
    <Card className="h-fit shadow-none">
      <CardHeader className="space-y-3 p-5 pb-4">
        <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
          <Icon className="h-5 w-5" />
        </div>
        <div>
          <CardTitle className="text-base">{title}</CardTitle>
          <CardDescription className="mt-1 leading-5">{description}</CardDescription>
        </div>
      </CardHeader>
      <CardContent className="space-y-4 p-5 pt-0">{children}</CardContent>
    </Card>
  );
}

function StatementListInput({
  label,
  values,
  onChange,
  placeholder,
  error,
}: {
  label: string;
  values: string[];
  onChange: (values: string[]) => void;
  placeholder: string;
  error?: string;
}) {
  const entries = values.length > 0 ? values : [""];

  const updateEntry = (index: number, nextValue: string) => {
    const next = [...entries];
    next[index] = nextValue;
    onChange(next);
  };

  const removeEntry = (index: number) => {
    const next = entries.filter((_, itemIndex) => itemIndex !== index);
    onChange(next.length > 0 ? next : [""]);
  };

  return (
    <div className="space-y-2">
      <Label>{label}</Label>
      <p className="text-xs text-muted-foreground">
        Add one concrete experience expectation per field.
      </p>
      <div className="space-y-2">
        {entries.map((entry, index) => (
          <div key={index} className="flex gap-2">
            <Input
              value={entry}
              onChange={(event) => updateEntry(index, event.target.value)}
              placeholder={index === 0 ? placeholder : "Add another experience expectation"}
              aria-label={`Expected experience ${index + 1}`}
              aria-invalid={Boolean(error)}
            />
            <Button
              type="button"
              variant="outline"
              size="icon"
              onClick={() => removeEntry(index)}
              disabled={entries.length === 1 && !entry}
              aria-label={`Remove expected experience ${index + 1}`}
            >
              <X className="h-4 w-4" />
            </Button>
          </div>
        ))}
      </div>
      <Button
        type="button"
        variant="outline"
        size="sm"
        className="gap-2"
        onClick={() => onChange([...entries, ""])}
      >
        <Plus className="h-4 w-4" />
        Add experience
      </Button>
      <FieldError message={error} />
    </div>
  );
}

function LanguageCertificateInputs({
  languageLabel,
  values,
  onChange,
  error,
}: {
  languageLabel: string;
  values: LanguageCertificateRequirement[];
  onChange: (values: LanguageCertificateRequirement[]) => void;
  error?: string;
}) {
  const updateCertificate = (
    index: number,
    patch: Partial<LanguageCertificateRequirement>,
  ) => {
    onChange(values.map((certificate, itemIndex) =>
      itemIndex === index ? { ...certificate, ...patch } : certificate));
  };

  return (
    <div className="space-y-2">
      <div>
        <Label>Certificates</Label>
        <p className="mt-1 text-xs text-muted-foreground">
          Optional — add each accepted certificate and its required score.
        </p>
      </div>
      {values.map((certificate, index) => (
        <div
          key={certificate.clientId ?? index}
          className="grid gap-2 rounded-lg border bg-secondary/20 p-3 sm:grid-cols-[1fr_1fr_auto]"
        >
          <Input
            value={certificate.certificateName}
            onChange={(event) => updateCertificate(index, {
              certificateName: event.target.value,
            })}
            placeholder="Certificate name, e.g. IELTS Academic"
            aria-label={`${languageLabel} certificate name ${index + 1}`}
            aria-invalid={Boolean(error)}
          />
          <Input
            value={certificate.minimumScore}
            onChange={(event) => updateCertificate(index, {
              minimumScore: event.target.value,
            })}
            placeholder="Required score, e.g. 6.5 overall"
            aria-label={`${languageLabel} certificate score ${index + 1}`}
            aria-invalid={Boolean(error)}
          />
          <Button
            type="button"
            variant="outline"
            size="icon"
            onClick={() => onChange(values.filter((_, itemIndex) => itemIndex !== index))}
            aria-label={`Remove ${languageLabel} certificate ${index + 1}`}
          >
            <X className="h-4 w-4" />
          </Button>
        </div>
      ))}
      <Button
        type="button"
        variant="outline"
        size="sm"
        className="gap-2"
        onClick={() => onChange([
          ...values,
          {
            certificateName: "",
            minimumScore: "",
            clientId: createRequirementClientId("certificate"),
          },
        ])}
      >
        <Plus className="h-4 w-4" />
        Add certificate
      </Button>
      <FieldError message={error} />
    </div>
  );
}

function TagInput({
  label,
  hint,
  values,
  onChange,
  placeholder,
  suggestions = [],
  error,
}: {
  label: string;
  hint?: string;
  values: string[];
  onChange: (values: string[]) => void;
  placeholder: string;
  suggestions?: string[];
  error?: string;
}) {
  const id = useId();
  const [draft, setDraft] = useState("");

  const addDraft = () => {
    const additions = draft
      .split(/[,;\n|]/)
      .map((item) => item.trim())
      .filter(Boolean);
    if (additions.length === 0) return;
    onChange(Array.from(new Set([...values, ...additions])));
    setDraft("");
  };

  const addSuggestion = (suggestion: string) => {
    if (!values.includes(suggestion)) onChange([...values, suggestion]);
  };

  const handleKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === "Enter" || event.key === ",") {
      event.preventDefault();
      addDraft();
    }
  };

  return (
    <div className="space-y-2">
      <div>
        <Label htmlFor={id}>{label}</Label>
        {hint ? <p className="mt-1 text-xs text-muted-foreground">{hint}</p> : null}
      </div>
      {values.length > 0 ? (
        <div className="flex flex-wrap gap-1.5">
          {values.map((item) => (
            <Badge key={item} variant="secondary" className="gap-1 py-1 pl-2.5 pr-1.5">
              {item}
              <button
                type="button"
                onClick={() => onChange(values.filter((value) => value !== item))}
                className="rounded-sm p-0.5 hover:bg-background"
                aria-label={`Remove ${item}`}
              >
                <X className="h-3 w-3" />
              </button>
            </Badge>
          ))}
        </div>
      ) : null}
      <div className="flex gap-2">
        <Input
          id={id}
          value={draft}
          onChange={(event) => setDraft(event.target.value)}
          onKeyDown={handleKeyDown}
          onBlur={addDraft}
          placeholder={placeholder}
          aria-invalid={Boolean(error)}
        />
        <Button
          type="button"
          variant="outline"
          size="icon"
          onMouseDown={(event) => event.preventDefault()}
          onClick={addDraft}
          disabled={!draft.trim()}
          aria-label={`Add ${label.toLowerCase()}`}
        >
          <Plus className="h-4 w-4" />
        </Button>
      </div>
      {suggestions.length > 0 ? (
        <div className="flex flex-wrap gap-1.5">
          {suggestions.filter((item) => !values.includes(item)).map((item) => (
            <button
              key={item}
              type="button"
              onClick={() => addSuggestion(item)}
              className="rounded-full border border-dashed px-2.5 py-1 text-xs text-muted-foreground transition-colors hover:border-primary/50 hover:bg-primary/5 hover:text-foreground"
            >
              + {item}
            </button>
          ))}
        </div>
      ) : null}
      <FieldError message={error} />
    </div>
  );
}

function ChoiceButton({
  selected,
  onClick,
  compact = false,
  children,
}: {
  selected: boolean;
  onClick: () => void;
  compact?: boolean;
  children: ReactNode;
}) {
  return (
    <button
      type="button"
      aria-pressed={selected}
      onClick={onClick}
      className={cn(
        "rounded-md border text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        compact ? "px-3 py-2" : "px-4 py-2.5",
        selected
          ? "border-primary bg-primary/10 text-primary"
          : "border-input bg-background text-muted-foreground hover:bg-accent hover:text-foreground",
      )}
    >
      {children}
    </button>
  );
}

function FieldError({ message }: { message?: string }) {
  return message ? <p className="text-xs text-destructive" role="alert">{message}</p> : null;
}
