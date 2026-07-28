import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { motion } from "framer-motion";
import {
  ArrowLeft,
  ArrowRight,
  BriefcaseBusiness,
  CheckCircle2,
  Loader2,
  Plus,
  RefreshCw,
  Save,
  Sparkles,
  Trash2,
  Trophy,
  UserRound,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { JobRequirementsForm } from "@/components/JobRequirementsForm";
import {
  AI_MATCH_OPTIONS,
  AI_SCORE_OPTIONS,
  createRecruiterJob,
  fetchJob,
  fetchRecruiter,
  fetchRecommendedCandidateSuggestion,
  fetchRecommendedCandidates,
  getJobId,
  updateRecruiterJob,
  type ApplicationField,
  type CvJobMatch,
  type Job,
  type JobRequirementDetails,
  type RecruiterCandidateMatch,
} from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";
import { toast } from "sonner";

const EMPTY_JOB_REQUIREMENTS: JobRequirementDetails = {
  educationMode: "",
  degrees: [],
  noDegreeRequirement: "",
  educationMajors: [],
  preferredInstitutions: [],
  minimumYearsExperience: undefined,
  experienceRequirements: [""],
  requiredSkills: [],
  techStack: [],
  englishRequired: undefined,
  englishLevel: "",
  englishSkills: [],
  englishCertificates: [],
  tools: [],
  technicalKnowledge: [],
};

const empty: Job = {
  jobTitle: "", aboutCompany: "",
  jobDescriptionTitle: "Job description", jobDescription: "",
  requirementsTitle: "Requirements", requirements: "",
  benefitsTitle: "Benefits", benefits: "",
  location: "", salaryRange: "", jobType: "", yoe: "", experienceLevel: "", industry: "",
  postedDate: "", applyingDeadline: "", startDate: "", endDate: "",
  customApplicationFields: "",
  requirementDetails: EMPTY_JOB_REQUIREMENTS,
};

const defaultFields: ApplicationField[] = [
  { id: "years_in_role", label: "How many years have you worked in this role?", type: "text", required: true },
  { id: "english_level", label: "Current English level", type: "select", required: true, options: ["Beginner", "Intermediate", "Upper-intermediate", "Advanced", "Fluent"] },
  { id: "cover_letter", label: "Cover letter", type: "textarea", required: false },
  { id: "portfolio_url", label: "Portfolio URL", type: "url", required: false },
];

export default function PostEditJob() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const isEdit = Boolean(id);

  const [form, setForm] = useState<Job>(empty);
  const [useCustomForm, setUseCustomForm] = useState(false);
  const [applicationFields, setApplicationFields] = useState<ApplicationField[]>(defaultFields);
  const [loading, setLoading] = useState(true);
  const [companyProfileDescription, setCompanyProfileDescription] = useState("");
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [publishedJob, setPublishedJob] = useState<Job | null>(null);
  const [recommendations, setRecommendations] = useState<RecruiterCandidateMatch[]>([]);
  const [recommendationLoading, setRecommendationLoading] = useState(false);
  const [recommendationError, setRecommendationError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;

    const loadFormContext = async () => {
      setLoading(true);
      const [profileResult, jobResult] = await Promise.allSettled([
        user?.id ? fetchRecruiter(user.id) : Promise.resolve(null),
        isEdit && id ? fetchJob(id) : Promise.resolve(null),
      ]);
      if (!active) return;

      const profileDescription = profileResult.status === "fulfilled"
        ? profileResult.value?.companyDescription?.trim() ?? ""
        : "";
      setCompanyProfileDescription(profileDescription);

      if (jobResult.status === "rejected") {
        toast.error("Failed to load job");
      } else if (jobResult.value) {
        const job = jobResult.value;
        setForm({
          ...empty,
          ...job,
          aboutCompany: profileDescription || job.aboutCompany || "",
        });
        const parsed = parseFields(job.customApplicationFields);
        if (parsed.length > 0) {
          setUseCustomForm(true);
          setApplicationFields(parsed);
        }
      } else if (profileDescription) {
        setForm((current) => ({ ...current, aboutCompany: profileDescription }));
      }
      setLoading(false);
    };

    void loadFormContext();
    return () => {
      active = false;
    };
  }, [id, isEdit, user?.id]);

  const update = (k: keyof Job, v: string) => setForm({ ...form, [k]: v });
  const updateRequirementDetails = (requirementDetails: JobRequirementDetails) => {
    setForm((current) => ({ ...current, requirementDetails }));
  };

  const updateField = (index: number, patch: Partial<ApplicationField>) => {
    setApplicationFields((current) => current.map((field, i) => i === index ? { ...field, ...patch } : field));
  };

  const addField = () => {
    setApplicationFields((current) => [...current, {
      id: `question_${Date.now()}`,
      label: "",
      type: "text",
      required: false,
      options: [],
    }]);
  };

  const loadRecommendations = async (job: Job) => {
    const jobId = getJobId(job);
    if (!user?.id || !jobId) {
      setRecommendationError("The job was saved, but its identifier is unavailable for matching.");
      return;
    }
    setRecommendationLoading(true);
    setRecommendationError(null);
    try {
      const ranking = await fetchRecommendedCandidates(user.id, jobId, 10, AI_SCORE_OPTIONS);
      setRecommendations(Array.isArray(ranking) ? ranking : []);
    } catch (error) {
      setRecommendationError(
        error instanceof ApiError
          ? error.message
          : "The job was saved, but candidate matching is temporarily unavailable.",
      );
    } finally {
      setRecommendationLoading(false);
    }
  };

  const submit = async () => {
    if (!user?.id) { toast.error("Missing recruiter ID"); return; }
    const validationErrors = validateJob(form);
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      toast.error("Please complete the highlighted job requirements.");
      return;
    }
    setSaving(true); setErrors({});
    try {
      const payload = {
        ...form,
        customApplicationFields: useCustomForm ? JSON.stringify(applicationFields.filter((field) => field.label.trim())) : "",
      };
      if (isEdit && id) {
        const updatedJob = await updateRecruiterJob(user.id, id, payload);
        setPublishedJob(updatedJob);
        toast.success("Job updated");
        await loadRecommendations(updatedJob);
      } else {
        const createdJob = await createRecruiterJob(user.id, payload);
        setPublishedJob(createdJob);
        toast.success("Job posted");
        await loadRecommendations(createdJob);
      }
    } catch (e) {
      if (e instanceof ApiError) {
        if (e.errors && !Array.isArray(e.errors)) setErrors(e.errors as Record<string, string>);
        toast.error(e.message);
      } else toast.error("Save failed");
    } finally { setSaving(false); }
  };

  if (loading) {
    return <div className="text-center pt-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>;
  }

  if (publishedJob) {
    return (
      <PublishedJobRecommendations
        job={publishedJob}
        recruiterId={user?.id}
        completionAction={isEdit ? "updated" : "published"}
        recommendations={recommendations}
        loading={recommendationLoading}
        error={recommendationError}
        onRetry={() => loadRecommendations(publishedJob)}
        onViewJob={() => navigate(`/jobs/${getJobId(publishedJob)}`)}
        onManageJobs={() => navigate("/recruiters/jobs")}
        onViewApplicant={(applicantId) => navigate(`/applicants/${applicantId}`)}
      />
    );
  }

  const field = (k: keyof Job, label: string, opts: { placeholder?: string; type?: string; rows?: number; textarea?: boolean; required?: boolean } = {}) => (
    <div className="space-y-1.5">
      <Label>{label}{opts.required ? " *" : ""}</Label>
      {opts.textarea ? (
        <Textarea rows={opts.rows ?? 3} value={String(form[k] ?? "")} onChange={(e) => update(k, e.target.value)} placeholder={opts.placeholder} required={opts.required} />
      ) : (
        <Input type={opts.type ?? "text"} value={String(form[k] ?? "")} onChange={(e) => update(k, e.target.value)} placeholder={opts.placeholder} required={opts.required} />
      )}
      {errors[k as string] && <p className="text-xs text-destructive">{errors[k as string]}</p>}
    </div>
  );

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6 space-y-5">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">{isEdit ? "Edit Job" : "Post New Job"}</h1>
          <p className="text-sm text-muted-foreground mt-1">{isEdit ? "Update job details" : "Create a new job posting"}</p>
        </div>

        <div className="grid lg:grid-cols-[1.2fr_0.8fr] gap-6 items-start">
          <div className="space-y-5">
            <div className="grid sm:grid-cols-2 gap-4">
              {field("jobTitle", "Job Title", { placeholder: "Senior Developer", required: true })}
              {field("location", "Location", { placeholder: "Remote" })}
              {field("jobType", "Job Type")}
              {field("experienceLevel", "Experience Level", { placeholder: "Mid / Senior" })}
              {field("industry", "Industry")}
              {field("salaryRange", "Salary Range", { placeholder: "$100K - $140K" })}
              {field("postedDate", "Posted Date", { type: "date" })}
              {field("applyingDeadline", "Application Deadline", { type: "date" })}
              {field("startDate", "Start Date", { type: "date" })}
              {field("endDate", "End Date", { type: "date" })}
            </div>

            {companyProfileDescription ? (
              <p className="rounded-lg border bg-secondary/30 px-4 py-3 text-sm text-muted-foreground">
                Company overview will be taken automatically from your recruiter profile.
              </p>
            ) : field("aboutCompany", "About Company", { textarea: true })}

            <JobContentSection
              titleField={field("jobDescriptionTitle", "Section title", {
                placeholder: "e.g. Job responsibilities",
              })}
              contentField={field("jobDescription", "Content", {
                textarea: true,
                rows: 4,
                placeholder: "Enter one responsibility per line",
              })}
            />
            <JobContentSection
              titleField={field("requirementsTitle", "Section title", {
                placeholder: "e.g. What you'll bring",
              })}
              contentField={field("requirements", "Additional requirement notes", {
                textarea: true,
                rows: 3,
                placeholder: "Enter one requirement per line",
              })}
            />
            <JobContentSection
              titleField={field("benefitsTitle", "Section title", {
                placeholder: "e.g. What we offer",
              })}
              contentField={field("benefits", "Content", {
                textarea: true,
                placeholder: "Enter one benefit per line",
              })}
            />
          </div>

          <div className="rounded-lg border bg-card p-5 space-y-4">
            <div className="flex items-start justify-between gap-3">
              <div>
                <h2 className="font-display font-semibold text-foreground">Applicant Form</h2>
                <p className="text-xs text-muted-foreground mt-1">Add questions applicants must answer when applying.</p>
              </div>
              <label className="flex items-center gap-2 text-xs text-muted-foreground">
                <input type="checkbox" checked={useCustomForm} onChange={(e) => setUseCustomForm(e.target.checked)} />
                Enable
              </label>
            </div>

            {useCustomForm && (
              <div className="space-y-4">
                {applicationFields.map((customField, index) => (
                  <div key={customField.id} className="rounded-lg border bg-secondary/30 p-3 space-y-3">
                    <div className="flex gap-2">
                      <Input value={customField.label} placeholder="Question label" onChange={(e) => updateField(index, { label: e.target.value })} />
                      <Button variant="outline" size="icon" onClick={() => setApplicationFields((current) => current.filter((_, i) => i !== index))}>
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <select value={customField.type} onChange={(e) => updateField(index, { type: e.target.value as ApplicationField["type"] })}
                        className="px-3 py-2 text-sm bg-background rounded-md border border-input">
                        <option value="text">Text</option>
                        <option value="textarea">Long text</option>
                        <option value="select">Select list</option>
                        <option value="url">URL</option>
                      </select>
                      <label className="flex items-center gap-2 text-xs text-muted-foreground px-2">
                        <input type="checkbox" checked={Boolean(customField.required)} onChange={(e) => updateField(index, { required: e.target.checked })} />
                        Required
                      </label>
                    </div>
                    {customField.type === "select" && (
                      <Input value={(customField.options || []).join(", ")} placeholder="Options separated by comma"
                        onChange={(e) => updateField(index, { options: e.target.value.split(",").map((item) => item.trim()).filter(Boolean) })} />
                    )}
                  </div>
                ))}
                <Button type="button" variant="outline" size="sm" className="gap-2" onClick={addField}>
                  <Plus className="w-4 h-4" /> Add Question
                </Button>
              </div>
            )}
          </div>
        </div>

        <JobRequirementsForm
          value={form.requirementDetails ?? EMPTY_JOB_REQUIREMENTS}
          onChange={updateRequirementDetails}
          errors={errors}
        />

        <div className="flex gap-3">
          <Button onClick={submit} disabled={saving} className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2">
            {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
            {isEdit ? "Save Changes" : "Publish Job"}
          </Button>
          <Button variant="outline" onClick={() => navigate(-1)}>Cancel</Button>
        </div>
      </motion.div>
    </div>
  );
}

function JobContentSection({
  titleField,
  contentField,
}: {
  titleField: React.ReactNode;
  contentField: React.ReactNode;
}) {
  return (
    <div className="grid gap-3 rounded-lg border bg-secondary/20 p-4 sm:grid-cols-[minmax(180px,0.35fr)_1fr]">
      {titleField}
      {contentField}
    </div>
  );
}

function validateJob(job: Job): Record<string, string> {
  const errors: Record<string, string> = {};
  const details = job.requirementDetails;

  if (!job.jobTitle?.trim()) errors.jobTitle = "Job title is required";
  if (!details?.educationMode) {
    errors["requirementDetails.educationMode"] = "Select how degrees should be evaluated";
  } else if (details.educationMode === "NOT_REQUIRED") {
    if (!details.noDegreeRequirement?.trim()) {
      errors["requirementDetails.noDegreeRequirement"] =
        "Describe what you expect from an applicant without a degree";
    }
  } else if (details.educationMode !== "NOT_REQUIRED") {
    if (details.degrees.length === 0) {
      errors["requirementDetails.degrees"] = "Select at least one degree";
    } else if (details.educationMode === "MINIMUM" && details.degrees.length !== 1) {
      errors["requirementDetails.degrees"] = "Select exactly one minimum degree";
    }
    if (details.educationMajors.length === 0) {
      errors["requirementDetails.educationMajors"] = "Add at least one relevant major";
    }
  }
  if (details?.minimumYearsExperience === undefined
    || !Number.isInteger(details.minimumYearsExperience)
    || details.minimumYearsExperience < 0) {
    errors["requirementDetails.minimumYearsExperience"] = "Enter a whole number of zero or more";
  }
  if (!details?.experienceRequirements.some((item) => item.trim())) {
    errors["requirementDetails.experienceRequirements"] = "Add at least one expected experience";
  }
  if (!details?.requiredSkills.length) {
    errors["requirementDetails.requiredSkills"] = "Add at least one required skill";
  }
  if (!details?.techStack.length) {
    errors["requirementDetails.techStack"] = "Add at least one technology";
  }
  if (details?.englishRequired === undefined) {
    errors["requirementDetails.englishRequired"] = "Choose whether English is required";
  } else if (details.englishRequired) {
    if (!details.englishLevel?.trim()) {
      errors["requirementDetails.englishLevel"] = "Select the minimum English level";
    }
    if (details.englishSkills.length === 0) {
      errors["requirementDetails.englishSkills"] = "Select at least one English skill";
    }
    if (details.englishCertificates.some(
      (certificate) => !certificate.certificateName.trim() || !certificate.minimumScore.trim(),
    )) {
      errors["requirementDetails.englishCertificates"] =
        "Complete both the certificate name and required score";
    }
  }
  if (!details || (details.tools.length === 0 && details.technicalKnowledge.length === 0)) {
    errors["requirementDetails.toolsOrTechnicalKnowledge"] =
      "Add at least one tool or technical knowledge item";
  }
  return errors;
}

function PublishedJobRecommendations({
  job,
  recruiterId,
  completionAction,
  recommendations,
  loading,
  error,
  onRetry,
  onViewJob,
  onManageJobs,
  onViewApplicant,
}: {
  job: Job;
  recruiterId?: string | number;
  completionAction: "published" | "updated";
  recommendations: RecruiterCandidateMatch[];
  loading: boolean;
  error: string | null;
  onRetry: () => void;
  onViewJob: () => void;
  onManageJobs: () => void;
  onViewApplicant: (applicantId: string | number) => void;
}) {
  const [suggestions, setSuggestions] = useState<Record<string, CvJobMatch>>({});
  const [suggestionLoading, setSuggestionLoading] = useState<Record<string, boolean>>({});
  const [suggestionErrors, setSuggestionErrors] = useState<Record<string, string>>({});
  const [suggestionOpen, setSuggestionOpen] = useState<Record<string, boolean>>({});
  const jobId = getJobId(job);

  const handleSuggestion = async (applicantId: string | number) => {
    const key = String(applicantId);
    if (suggestions[key]) {
      setSuggestionOpen((current) => ({ ...current, [key]: !current[key] }));
      return;
    }
    if (!recruiterId || !jobId) return;
    setSuggestionLoading((current) => ({ ...current, [key]: true }));
    setSuggestionErrors((current) => ({ ...current, [key]: "" }));
    try {
      const result = await fetchRecommendedCandidateSuggestion(
        recruiterId,
        jobId,
        applicantId,
        AI_MATCH_OPTIONS,
      );
      setSuggestions((current) => ({ ...current, [key]: result }));
      setSuggestionOpen((current) => ({ ...current, [key]: true }));
    } catch (error) {
      setSuggestionErrors((current) => ({
        ...current,
        [key]: error instanceof ApiError ? error.message : "AI suggestion is temporarily unavailable.",
      }));
    } finally {
      setSuggestionLoading((current) => ({ ...current, [key]: false }));
    }
  };

  const wasUpdated = completionAction === "updated";

  return (
    <div className="mx-auto max-w-5xl space-y-6">
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        className="rounded-xl border border-primary/25 bg-primary/5 p-6"
      >
        <div className="flex flex-col justify-between gap-5 sm:flex-row sm:items-center">
          <div className="flex items-start gap-4">
            <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground">
              <CheckCircle2 className="h-6 w-6" />
            </div>
            <div>
              <p className="font-display text-2xl font-bold text-foreground">
                {wasUpdated ? "Job updated successfully" : "Job published successfully"}
              </p>
              <p className="mt-1 text-base text-muted-foreground">
                {job.jobTitle || job.title} {wasUpdated ? "has been updated" : "is live"}. Here are the strongest matching candidates.
              </p>
            </div>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button variant="outline" onClick={onManageJobs}>Manage jobs</Button>
            <Button onClick={onViewJob} className="gap-2">
              View job <ArrowRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </motion.div>

      <div className="rounded-xl border bg-card p-6">
        <div className="flex flex-col justify-between gap-3 sm:flex-row sm:items-start">
          <div>
            <div className="flex items-center gap-2">
              <Sparkles className="h-5 w-5 text-primary" />
              <h1 className="font-display text-xl font-bold text-foreground">Top matching candidates</h1>
            </div>
            <p className="mt-2 max-w-2xl text-base leading-7 text-muted-foreground">
              Ranked by CV-to-job match score. Open-to-work candidates with an uploaded CV are included.
            </p>
          </div>
          {!loading ? (
            <Button variant="outline" size="sm" onClick={onRetry} className="gap-2">
              <RefreshCw className="h-4 w-4" /> Refresh ranking
            </Button>
          ) : null}
        </div>

        {loading ? (
          <div className="flex min-h-48 items-center justify-center gap-3 text-muted-foreground">
            <Loader2 className="h-5 w-5 animate-spin text-primary" />
            <span>Matching candidate CVs to this job...</span>
          </div>
        ) : error ? (
          <div className="mt-6 rounded-lg border border-destructive/30 bg-destructive/5 p-5">
            <p className="text-sm text-destructive">{error}</p>
            <Button variant="outline" size="sm" onClick={onRetry} className="mt-3 gap-2">
              <RefreshCw className="h-4 w-4" /> Try matching again
            </Button>
          </div>
        ) : recommendations.length === 0 ? (
          <div className="mt-6 rounded-lg border border-dashed p-8 text-center">
            <UserRound className="mx-auto h-8 w-8 text-muted-foreground" />
            <p className="mt-3 font-medium text-foreground">No eligible candidates found yet</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Candidates need an uploaded CV and Open to Work status.
            </p>
          </div>
        ) : (
          <div className="mt-6 space-y-3">
            {recommendations.map((item) => {
              const applicant = item.applicant ?? {};
              const applicantKey = String(applicant.id ?? item.rank);
              const skills = candidateSkills(applicant);
              const currentRole = candidateCurrentRole(applicant);
              const suggestion = suggestions[applicantKey];
              return (
                <motion.div
                  key={applicantKey}
                  initial={{ opacity: 0, y: 8 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: item.rank * 0.035 }}
                  className="grid gap-4 rounded-lg border bg-background p-5 sm:grid-cols-[auto_minmax(0,1fr)_auto] sm:items-start"
                >
                  <div className={`flex h-11 w-11 items-center justify-center rounded-full font-display font-bold ${item.rank === 1 ? "bg-warning/15 text-warning" : "bg-secondary text-foreground"
                    }`}>
                    {item.rank === 1 ? <Trophy className="h-5 w-5" /> : `#${item.rank}`}
                  </div>
                  <div className="min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <p className="font-display text-lg font-semibold text-foreground">
                        {applicant.fullName || `Candidate #${item.rank}`}
                      </p>
                      {applicant.status ? <Badge variant="outline">{applicant.status}</Badge> : null}
                    </div>
                    <div className="mt-1 flex flex-wrap gap-x-4 gap-y-1 text-sm text-muted-foreground">
                      {currentRole ? (
                        <span className="flex items-center gap-1.5">
                          <BriefcaseBusiness className="h-4 w-4" /> {currentRole}
                        </span>
                      ) : null}
                      {applicant.address ? <span>{applicant.address}</span> : null}
                    </div>
                    {skills.length > 0 ? (
                      <div className="mt-3 flex flex-wrap gap-1.5">
                        {skills.slice(0, 6).map((skill) => (
                          <Badge key={skill} variant="secondary">{skill}</Badge>
                        ))}
                      </div>
                    ) : null}
                  </div>
                  <div className="flex items-center justify-between gap-3 sm:flex-col sm:items-end">
                    <Badge className="bg-primary px-3 py-1 text-sm text-primary-foreground">
                      {item.match?.matchPercent ?? 0}% match
                    </Badge>
                    {applicant.id ? (
                      <>
                        <Button
                          size="sm"
                          onClick={() => handleSuggestion(applicant.id!)}
                          disabled={Boolean(suggestionLoading[applicantKey])}
                          className="gap-1.5"
                        >
                          {suggestionLoading[applicantKey]
                            ? <Loader2 className="h-3.5 w-3.5 animate-spin" />
                            : <Sparkles className="h-3.5 w-3.5" />}
                          {suggestionLoading[applicantKey]
                            ? "Generating..."
                            : suggestion
                              ? (suggestionOpen[applicantKey] ? "Hide AI" : "Show AI")
                              : "AI Suggestion"}
                        </Button>
                        <Button variant="ghost" size="sm" onClick={() => onViewApplicant(applicant.id!)} className="gap-1">
                          View profile <ArrowRight className="h-3.5 w-3.5" />
                        </Button>
                      </>
                    ) : null}
                  </div>
                  {suggestionErrors[applicantKey] ? (
                    <p className="text-sm text-destructive sm:col-start-2 sm:col-span-2">
                      {suggestionErrors[applicantKey]}
                    </p>
                  ) : null}
                  {suggestion && suggestionOpen[applicantKey] ? (
                    <CandidateSuggestionDetails match={suggestion} />
                  ) : null}
                </motion.div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

function CandidateSuggestionDetails({ match }: { match: CvJobMatch }) {
  const fieldScores = Object.entries(match.perFieldScores ?? {})
    .sort(([, left], [, right]) => right - left);
  return (
    <div className="space-y-4 rounded-lg border border-primary/20 bg-primary/5 p-4 sm:col-start-2 sm:col-span-2">
      <div>
        <h3 className="font-display text-sm font-semibold text-foreground">Why this candidate matches</h3>
        <p className="mt-1 text-sm leading-6 text-muted-foreground">
          {match.reason || "The AI service did not return a detailed explanation."}
        </p>
      </div>
      {fieldScores.length > 0 ? (
        <div className="grid gap-3 sm:grid-cols-2">
          {fieldScores.map(([field, score]) => {
            const percent = Math.round(score * 100);
            return (
              <div key={field}>
                <div className="mb-1 flex justify-between text-xs text-muted-foreground">
                  <span>{humanizeMatchField(field)}</span>
                  <span>{percent}%</span>
                </div>
                <div className="h-1.5 overflow-hidden rounded-full bg-secondary">
                  <div className="h-full rounded-full bg-primary" style={{ width: `${percent}%` }} />
                </div>
              </div>
            );
          })}
        </div>
      ) : null}
      {match.suggestions && match.suggestions.length > 0 ? (
        <div>
          <h3 className="text-xs font-semibold uppercase tracking-wide text-foreground">AI suggestions</h3>
          <ul className="mt-2 space-y-1.5 text-sm text-muted-foreground">
            {match.suggestions.map((suggestion) => <li key={suggestion}>• {suggestion}</li>)}
          </ul>
        </div>
      ) : null}
    </div>
  );
}

function humanizeMatchField(value: string): string {
  return value.toLowerCase().replace(/_/g, " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function candidateSkills(applicant: RecruiterCandidateMatch["applicant"]): string[] {
  const raw = applicant.cv?.skills;
  if (Array.isArray(raw)) return raw.filter(Boolean);
  return typeof raw === "string" ? raw.split(/[\n,;|]/).map((item) => item.trim()).filter(Boolean) : [];
}

function candidateCurrentRole(applicant: RecruiterCandidateMatch["applicant"]): string | null {
  const experience = applicant.cv?.experience;
  if (experience && typeof experience === "object") {
    return experience.jobTitle || experience.companyName || null;
  }
  return typeof experience === "string" && experience.trim() ? experience.trim() : null;
}

function parseFields(raw?: string): ApplicationField[] {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}
