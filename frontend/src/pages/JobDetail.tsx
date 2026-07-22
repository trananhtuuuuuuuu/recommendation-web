import { useCallback, useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { AnimatePresence, motion } from "framer-motion";
import type { LucideIcon } from "lucide-react";
import {
  AlertCircle,
  ArrowLeft,
  Banknote,
  Bookmark,
  Briefcase,
  Building2,
  Calendar,
  ChevronDown,
  ChevronUp,
  Clock,
  Info,
  Loader2,
  MapPin,
  ShieldCheck,
  Sparkles,
  Users,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  applyJob,
  AI_MATCH_OPTIONS,
  fetchAnonymousCandidatePreviews,
  fetchApplicantActivityCount,
  fetchJob,
  fetchJobApplicantCount,
  matchCvToJob,
  matchRecruiterApplicants,
  getApplyingDeadline,
  saveJob,
  type ApplicationField,
  type AnonymousCandidatePreviews,
  type ApplicantActivityCount,
  type CvJobMatch,
  type Job,
  type JobApplicantsCount,
  type RecruiterApplicantMatch,
} from "@/lib/jobsApi";
import { ApiError } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";

export default function JobDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user, role, isAuthenticated } = useAuth();
  const [job, setJob] = useState<Job | null>(null);
  const [applicantsCount, setApplicantsCount] = useState<number | null>(null);
  const [applicantActivity, setApplicantActivity] = useState<ApplicantActivityCount | null>(null);
  const [applicantActivityLoading, setApplicantActivityLoading] = useState(false);
  const [applicantActivityError, setApplicantActivityError] = useState<string | null>(null);
  const [anonymousPreviews, setAnonymousPreviews] = useState<AnonymousCandidatePreviews | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);
  const [applied, setApplied] = useState(false);
  const [saving, setSaving] = useState(false);
  const [applying, setApplying] = useState(false);
  const [showApplyForm, setShowApplyForm] = useState(false);
  const [applicationAnswers, setApplicationAnswers] = useState<Record<string, string>>({});
  const [matchResult, setMatchResult] = useState<CvJobMatch | null>(null);
  const [matching, setMatching] = useState(false);
  const [matchExpanded, setMatchExpanded] = useState(false);
  const [recruiterMatches, setRecruiterMatches] = useState<RecruiterApplicantMatch[] | null>(null);
  const [recruiterMatching, setRecruiterMatching] = useState(false);
  const [recruiterMatchExpanded, setRecruiterMatchExpanded] = useState(false);

  const loadApplicantPrivacy = useCallback(async (jobId: string | number, active = true) => {
    setApplicantActivityLoading(true);
    setApplicantActivityError(null);
    const [countResult, previewResult] = await Promise.allSettled([
      fetchApplicantActivityCount(jobId),
      fetchAnonymousCandidatePreviews(jobId),
    ]);
    if (!active) return;
    if (countResult.status === "fulfilled") {
      setApplicantActivity(countResult.value);
    } else {
      setApplicantActivity(null);
      setApplicantActivityError(
        countResult.reason instanceof ApiError
          ? countResult.reason.message
          : "Applicant activity is unavailable right now.",
      );
    }
    if (previewResult.status === "fulfilled" && previewResult.value.available) {
      setAnonymousPreviews(previewResult.value);
    } else {
      setAnonymousPreviews(null);
    }
    setApplicantActivityLoading(false);
  }, []);

  useEffect(() => {
    if (!id) return;
    let active = true;
    setLoading(true);
    fetchJob(id)
      .then((j) => { if (active) setJob(j); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load job"); })
      .finally(() => { if (active) setLoading(false); });

    if (role === "APPLICANT") {
      loadApplicantPrivacy(id, active);
    } else if (role === "RECRUITER" || role === "ADMIN") {
      fetchJobApplicantCount(id)
        .then((res) => {
          if (!active) return;
          const normalized = normalizeApplicantCount(res);
          setApplicantsCount(normalized);
        })
        .catch(() => { /* non-fatal */ });
    }
    return () => { active = false; };
  }, [id, role, loadApplicantPrivacy]);

  const handleSave = async () => {
    if (!isAuthenticated) { navigate("/auth"); return; }
    if (role !== "APPLICANT") { toast.error("Only applicants can save jobs."); return; }
    if (!user?.id || !id) return;
    setSaving(true);
    try {
      await saveJob(user.id, id);
      setSaved(true);
      toast.success("Job saved.");
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Failed to save");
    } finally { setSaving(false); }
  };

  const handleMatch = async () => {
    if (!isAuthenticated) { navigate("/auth"); return; }
    if (role !== "APPLICANT") { toast.error("Only applicants can check match score."); return; }
    if (!user?.id || !id) return;
    setMatching(true);
    try {
      const result = await matchCvToJob(user.id, id, AI_MATCH_OPTIONS);
      setMatchResult(result);
      setMatchExpanded(true);
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Match failed. Make sure your CV is uploaded.");
    } finally { setMatching(false); }
  };

  const handleRecruiterMatch = async () => {
    if (!user?.id || !id || role !== "RECRUITER") return;
    setRecruiterMatching(true);
    try {
      const ranking = await matchRecruiterApplicants(user.id, id, { llm: false, method: "tfidf" });
      setRecruiterMatches(ranking);
      setRecruiterMatchExpanded(true);
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Unable to rank candidates for this job.");
    } finally {
      setRecruiterMatching(false);
    }
  };

  const customFields = parseApplicationFields(job?.customApplicationFields);
  const applicationFields = customFields.length > 0 ? customFields : defaultApplicationFields;
  const handleApply = async () => {
    if (!isAuthenticated) { navigate("/auth"); return; }
    if (role !== "APPLICANT") { toast.error("Only applicants can apply for jobs."); return; }
    if (!user?.id || !id) return;
    const missing = applicationFields.find((field) => field.required && !applicationAnswers[field.id]?.trim());
    if (missing) {
      toast.error(`Please answer: ${missing.label}`);
      return;
    }
    setApplying(true);
    try {
      await applyJob(user.id, id, {
        coverLetter: applicationAnswers.cover_letter || "",
        portfolioUrl: applicationAnswers.portfolio_url || "",
        applicationAnswers: JSON.stringify(applicationAnswers),
      });
      await loadApplicantPrivacy(id);
      setApplied(true);
      setShowApplyForm(false);
      toast.success("Application submitted.");
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Failed to apply");
    } finally { setApplying(false); }
  };

  if (loading) {
    return <div className="max-w-4xl mx-auto pt-8 text-center text-sm text-muted-foreground">
      <Loader2 className="w-5 h-5 animate-spin mx-auto" /></div>;
  }
  if (error || !job) {
    return (
      <div className="max-w-lg mx-auto pt-16 text-center space-y-3">
        <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
        <p className="text-sm text-foreground">{error ?? "Job not found"}</p>
        <Button variant="outline" onClick={() => navigate("/jobs")}>Back to jobs</Button>
      </div>
    );
  }

  const isPostingRecruiter = role === "RECRUITER"
    && String(job.recruiterId ?? "") === String(user?.id ?? "");

  return (
    <div className="mx-auto max-w-7xl space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
        <motion.article
          initial={{ opacity: 0, y: 15 }}
          animate={{ opacity: 1, y: 0 }}
          className="glass-card space-y-7 rounded-xl p-6 sm:p-8"
        >
          <div className="border-b border-border pb-6">
            <div className="flex flex-wrap items-center gap-2">
              {job.jobType ? <Badge variant="outline">{job.jobType}</Badge> : null}
              {job.experienceLevel ? <Badge variant="outline">{job.experienceLevel}</Badge> : null}
              {applicantsCount !== null ? (
                <Badge className="bg-primary/10 text-primary">
                  <Users className="mr-1 h-3 w-3" /> {applicantsCount} applicants
                </Badge>
              ) : null}
            </div>
            <h1 className="mt-4 font-display text-3xl font-bold leading-tight text-foreground sm:text-4xl">
              {job.jobTitle || job.title}
            </h1>
            <div className="mt-4 flex flex-wrap gap-x-5 gap-y-2 text-sm text-muted-foreground">
              {job.companyName ? <span className="flex items-center gap-1.5"><Building2 className="h-3.5 w-3.5" /> {job.companyName}</span> : null}
              {job.location ? <span className="flex items-center gap-1.5"><MapPin className="h-3.5 w-3.5" /> {job.location}</span> : null}
              {job.postedDate ? <span className="flex items-center gap-1.5"><Clock className="h-3.5 w-3.5" /> Posted {job.postedDate}</span> : null}
            </div>
          </div>

          {job.aboutCompany ? (
            <Section title="About the company"><p className="text-sm leading-7 text-muted-foreground">{job.aboutCompany}</p></Section>
          ) : null}
          {job.jobDescription || job.description ? (
            <Section title="Role description">
              <p className="whitespace-pre-line text-sm leading-7 text-muted-foreground">{job.jobDescription || job.description}</p>
            </Section>
          ) : null}
          {job.requirements ? (
            <Section title="Requirements">
              <p className="whitespace-pre-line text-sm leading-7 text-muted-foreground">{job.requirements}</p>
            </Section>
          ) : null}
          {job.benefits ? (
            <Section title="Benefits">
              <p className="whitespace-pre-line text-sm leading-7 text-muted-foreground">{job.benefits}</p>
            </Section>
          ) : null}

          {role === "APPLICANT" ? (
            <Section title="Applicant activity">
              {applicantActivityLoading ? (
                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                  <Loader2 className="h-4 w-4 animate-spin" />
                  Loading approximate applicant activity...
                </div>
              ) : applicantActivity ? (
                <div className="space-y-2">
                  <p className="text-sm font-medium text-foreground">{applicantActivity.displayText}</p>
                  <p className="flex items-start gap-2 text-xs leading-5 text-muted-foreground">
                    <Info className="mt-0.5 h-3.5 w-3.5 shrink-0" />
                    This count is intentionally approximate to protect applicant privacy.
                  </p>
                </div>
              ) : (
                <div className="space-y-3">
                  <p className="text-sm text-muted-foreground">
                    {applicantActivityError ?? "Applicant activity is unavailable right now."}
                  </p>
                  <Button variant="outline" size="sm" onClick={() => id && loadApplicantPrivacy(id)}>
                    Retry
                  </Button>
                </div>
              )}
            </Section>
          ) : null}

          {role === "APPLICANT" && anonymousPreviews?.available && anonymousPreviews.profiles.length > 0 ? (
            <Section title="Anonymous candidate preview">
              <p className="text-xs leading-5 text-muted-foreground">
                These candidates chose to share a limited anonymous profile. Identifying details are hidden.
              </p>
              <div className="mt-4 grid gap-3 sm:grid-cols-2">
                {anonymousPreviews.profiles.map((profile) => (
                  <div key={profile.anonymousProfileId} className="rounded-lg border bg-card p-4">
                    <p className="text-sm font-semibold text-foreground">Candidate</p>
                    <div className="mt-3 space-y-1.5 text-xs leading-5 text-muted-foreground">
                      <p>Experience: <span className="text-foreground">{profile.experienceLevel || "Not specified"}</span></p>
                      <p>Areas: <span className="text-foreground">{profile.skillCategories?.join(", ") || "Not specified"}</span></p>
                      <p>Education: <span className="text-foreground">{profile.educationLevel || "Not specified"}</span></p>
                      <p>Region: <span className="text-foreground">{profile.generalRegion || "Not specified"}</span></p>
                    </div>
                  </div>
                ))}
              </div>
            </Section>
          ) : null}

          <div className="flex flex-wrap gap-4 border-t border-border pt-5 text-xs text-muted-foreground">
            {job.industry ? <span>Industry: <span className="text-foreground">{job.industry}</span></span> : null}
            {job.startDate ? <span>Start: <span className="text-foreground">{job.startDate}</span></span> : null}
            {job.endDate ? <span>End: <span className="text-foreground">{job.endDate}</span></span> : null}
          </div>
        </motion.article>

        <aside className="space-y-4 xl:sticky xl:top-20">
          <div className="rounded-xl border bg-card p-5 shadow-sm">
            <p className="text-xs font-medium uppercase tracking-[0.14em] text-muted-foreground">Role overview</p>
            <p className="mt-3 font-display text-xl font-bold text-foreground">{job.salaryRange || "Salary not listed"}</p>
            <div className="mt-5 space-y-3">
              <OverviewRow icon={Briefcase} label="Employment" value={job.jobType} />
              <OverviewRow icon={MapPin} label="Location" value={job.location} />
              <OverviewRow icon={Banknote} label="Salary" value={job.salaryRange} />
              <OverviewRow icon={Calendar} label="Apply by" value={getApplyingDeadline(job)} />
            </div>

            <div className="mt-6 grid gap-2">
              {!isAuthenticated ? (
                <Button onClick={() => navigate("/auth")} className="w-full gap-2">
                  <Briefcase className="h-4 w-4" /> Sign in to apply
                </Button>
              ) : null}
              {role === "APPLICANT" ? (
                <>
                  <Button onClick={() => setShowApplyForm(true)} disabled={applied} className="w-full gap-2">
                    <Briefcase className="h-4 w-4" />
                    {applied ? "Application submitted" : "Apply for this role"}
                  </Button>
                  <Button variant="outline" onClick={handleSave} disabled={saving} className="w-full gap-2">
                    {saving ? <Loader2 className="h-4 w-4 animate-spin" /> :
                      <Bookmark className={`h-4 w-4 ${saved ? "fill-primary text-primary" : ""}`} />}
                    {saved ? "Saved to My Jobs" : "Save for later"}
                  </Button>
                </>
              ) : null}
              {(isPostingRecruiter || role === "ADMIN") && id ? (
                <Button variant="outline" onClick={() => navigate(`/jobs/${id}/applicants`)} className="w-full gap-2">
                  <Users className="h-4 w-4" /> View applicants
                </Button>
              ) : null}
              {job.recruiterId ? (
                <Button variant="ghost" onClick={() => navigate(`/recruiters/${job.recruiterId}`)} className="w-full gap-2">
                  <Building2 className="h-4 w-4" /> Recruiter profile
                </Button>
              ) : null}
            </div>
          </div>

          <div className="rounded-xl border border-primary/20 bg-primary/5 p-5">
            <div className="flex items-start gap-3">
              <ShieldCheck className="mt-0.5 h-5 w-5 shrink-0 text-primary" />
              <div>
                <h2 className="font-display text-sm font-semibold text-foreground">Apply with profile context</h2>
                <p className="mt-1 text-xs leading-5 text-muted-foreground">
                  Your saved applicant profile and CV are used with the answers requested for this role.
                </p>
              </div>
            </div>
          </div>

          {role === "APPLICANT" ? (
            <MatchPanel
              matching={matching}
              matchResult={matchResult}
              expanded={matchExpanded}
              onCheck={handleMatch}
              onToggle={() => setMatchExpanded((current) => !current)}
            />
          ) : null}

          {isPostingRecruiter ? (
            <RecruiterMatchPanel
              matching={recruiterMatching}
              matches={recruiterMatches}
              expanded={recruiterMatchExpanded}
              onCheck={handleRecruiterMatch}
              onToggle={() => setRecruiterMatchExpanded((current) => !current)}
              onViewAll={() => navigate(`/jobs/${id}/applicants`)}
            />
          ) : null}
        </aside>
      </div>

      {showApplyForm && (
        <div className="fixed inset-0 z-50 bg-foreground/40 flex items-start justify-center p-4 pt-12 overflow-y-auto" onClick={(event) => event.target === event.currentTarget && setShowApplyForm(false)}>
          <div className="w-full max-w-2xl rounded-lg border bg-background p-6 shadow-xl space-y-5">
            <div>
              <h2 className="font-display text-xl font-bold text-foreground">Apply for {job.jobTitle || job.title}</h2>
              <p className="text-sm text-muted-foreground mt-1">Your saved CV/profile will be attached. Complete the recruiter questions before submitting.</p>
            </div>
            <div className="space-y-4">
              {applicationFields.map((field) => (
                <ApplicationFieldInput
                  key={field.id}
                  field={field}
                  value={applicationAnswers[field.id] || ""}
                  onChange={(value) => setApplicationAnswers((current) => ({ ...current, [field.id]: value }))}
                />
              ))}
            </div>
            <div className="flex gap-3 justify-end">
              <Button variant="outline" onClick={() => setShowApplyForm(false)}>Cancel</Button>
              <Button onClick={handleApply} disabled={applying} className="gap-2">
                {applying && <Loader2 className="w-4 h-4 animate-spin" />}
                Submit Application
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

const defaultApplicationFields: ApplicationField[] = [
  { id: "years_in_role", label: "How many years have you worked in this role?", type: "text", required: true },
  { id: "english_level", label: "Current English level", type: "select", required: true, options: ["Beginner", "Intermediate", "Upper-intermediate", "Advanced", "Fluent"] },
  { id: "cover_letter", label: "Cover letter", type: "textarea" },
  { id: "portfolio_url", label: "Portfolio URL", type: "url" },
];

function parseApplicationFields(raw?: string): ApplicationField[] {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

function normalizeApplicantCount(value: number | JobApplicantsCount): number | null {
  if (typeof value === "number") return value;
  return value.applicantCount ?? value.count ?? null;
}

function OverviewRow({ icon: Icon, label, value }: { icon: LucideIcon; label: string; value?: string }) {
  return (
    <div className="flex items-start gap-3">
      <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-secondary text-primary">
        <Icon className="h-4 w-4" />
      </span>
      <div className="min-w-0">
        <p className="text-[11px] text-muted-foreground">{label}</p>
        <p className="truncate text-sm font-medium text-foreground">{value || "Not provided"}</p>
      </div>
    </div>
  );
}

function ApplicationFieldInput({ field, value, onChange }: { field: ApplicationField; value: string; onChange: (value: string) => void }) {
  return (
    <div className="space-y-2">
      <Label>{field.label}{field.required ? " *" : ""}</Label>
      {field.type === "textarea" ? (
        <Textarea value={value} onChange={(event) => onChange(event.target.value)} />
      ) : field.type === "select" ? (
        <select value={value} onChange={(event) => onChange(event.target.value)} className="w-full px-3 py-2 text-sm bg-background rounded-md border border-input">
          <option value="">Select an option</option>
          {(field.options || []).map((option) => <option key={option} value={option}>{option}</option>)}
        </select>
      ) : (
        <Input type={field.type === "url" ? "url" : "text"} value={value} onChange={(event) => onChange(event.target.value)} />
      )}
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h3 className="font-display font-semibold text-foreground mb-2">{title}</h3>
      {children}
    </div>
  );
}

// ── AI Match Panel ────────────────────────────────────────────────────────────

const FIELD_LABELS: Record<string, string> = {
  SKILL: "Technical skills", SOFT_SKILL: "Soft skills", LANGUAGE: "Languages",
  CERTIFICATION: "Certifications", JOB_TITLE: "Job title", COMPANY: "Company background",
  EDUCATION: "Education", SUMMARY: "Professional summary", EXPERIENCE: "Work experience", PROJECT: "Projects",
};

function ScoreRing({ percent }: { percent: number }) {
  const r = 36;
  const circ = 2 * Math.PI * r;
  const dash = (percent / 100) * circ;
  const color = percent >= 70 ? "#22c55e" : percent >= 45 ? "#f59e0b" : "#ef4444";
  return (
    <svg width="88" height="88" viewBox="0 0 88 88" className="shrink-0" aria-label={`Match score ${percent}%`}>
      <circle cx="44" cy="44" r={r} fill="none" stroke="hsl(var(--border))" strokeWidth="8" />
      <circle
        cx="44" cy="44" r={r} fill="none" stroke={color} strokeWidth="8"
        strokeLinecap="round" strokeDasharray={`${dash} ${circ}`}
        transform="rotate(-90 44 44)"
        style={{ transition: "stroke-dasharray 0.6s ease" }}
      />
      <text x="44" y="48" textAnchor="middle" fontSize="16" fontWeight="700" fill={color}>
        {percent}%
      </text>
    </svg>
  );
}

function MatchPanel({
  matching, matchResult, expanded, onCheck, onToggle,
}: {
  matching: boolean;
  matchResult: CvJobMatch | null;
  expanded: boolean;
  onCheck: () => void;
  onToggle: () => void;
}) {
  const fieldOrder = [
    "SKILL", "JOB_TITLE", "EXPERIENCE", "EDUCATION",
    "SUMMARY", "CERTIFICATION", "PROJECT", "LANGUAGE", "SOFT_SKILL", "COMPANY",
  ];
  return (
    <div className="rounded-xl border bg-card p-5 space-y-4">
      <div className="flex items-center gap-2">
        <Sparkles className="h-4 w-4 text-primary" />
        <h2 id="ai-match-heading" className="font-display text-sm font-semibold text-foreground">
          AI CV Match
        </h2>
      </div>

      {!matchResult ? (
        <>
          <p className="text-xs text-muted-foreground leading-5">
            Check how well your uploaded CV matches this job across 10 fields (skills,
            experience, education, language, and more).
          </p>
          <Button
            id="check-match-btn"
            onClick={onCheck}
            disabled={matching}
            variant="outline"
            className="w-full gap-2 border-primary/30 text-primary hover:bg-primary/10"
          >
            {matching ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
            {matching ? "Analysing..." : "AI Suggestion"}
          </Button>
        </>
      ) : (
        <>
          <Button
            id="check-match-btn"
            onClick={onToggle}
            disabled={matching}
            variant="outline"
            className="w-full gap-2 border-primary/30 text-primary hover:bg-primary/10"
          >
            {matching ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
            {expanded ? "Hide AI" : "Show AI"}
            {expanded ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
          </Button>

          <AnimatePresence>
            {expanded ? (
              <motion.div
                initial={{ height: 0, opacity: 0 }}
                animate={{ height: "auto", opacity: 1 }}
                exit={{ height: 0, opacity: 0 }}
                className="overflow-hidden"
              >
                <div className="space-y-4 pt-1">
                  <div className="flex items-center gap-4">
                    <ScoreRing percent={matchResult.matchPercent ?? 0} />
                    <div className="min-w-0">
                      <p className="text-xs font-medium text-muted-foreground">
                        {matchResult.passedFilter ? "Passed initial filter" : "Did not pass filter"}
                      </p>
                      <p className="mt-1 text-xs leading-5 text-foreground line-clamp-3">
                        {matchResult.reason}
                      </p>
                    </div>
                  </div>

                  {matchResult.perFieldScores && Object.keys(matchResult.perFieldScores).length > 0 ? (
                    <div className="space-y-1.5">
                      {fieldOrder
                        .filter((f) => matchResult.perFieldScores![f] !== undefined)
                        .map((field) => {
                          const pct = Math.round((matchResult.perFieldScores![field] ?? 0) * 100);
                          return (
                            <div key={field}>
                              <div className="flex justify-between text-[11px] text-muted-foreground mb-0.5">
                                <span>{FIELD_LABELS[field] ?? field}</span>
                                <span>{pct}%</span>
                              </div>
                              <div className="h-1.5 rounded-full bg-secondary overflow-hidden">
                                <div
                                  className="h-full rounded-full bg-primary transition-all duration-500"
                                  style={{ width: `${pct}%` }}
                                />
                              </div>
                            </div>
                          );
                        })}
                    </div>
                  ) : null}

                  {matchResult.hardFilterReasons && matchResult.hardFilterReasons.length > 0 ? (
                    <div className="rounded-lg bg-destructive/10 p-3 text-xs text-destructive space-y-1">
                      {matchResult.hardFilterReasons.map((r, i) => <p key={i}>{r}</p>)}
                    </div>
                  ) : null}

                  {matchResult.suggestions && matchResult.suggestions.length > 0 ? (
                    <div className="space-y-1.5">
                      <p className="text-[11px] font-medium text-muted-foreground uppercase tracking-wide">Improvement suggestions</p>
                      <ul className="space-y-1.5">
                        {matchResult.suggestions.map((s, i) => (
                          <li key={i} className="flex gap-2 text-xs leading-5 text-foreground">
                            <span className="mt-0.5 h-3.5 w-3.5 shrink-0 rounded-full bg-primary/15 text-primary flex items-center justify-center text-[9px] font-bold">{i + 1}</span>
                            {s}
                          </li>
                        ))}
                      </ul>
                    </div>
                  ) : null}

                  <Button
                    id="recheck-match-btn"
                    onClick={onCheck}
                    disabled={matching}
                    variant="ghost"
                    size="sm"
                    className="w-full gap-1 text-muted-foreground"
                  >
                    {matching ? <Loader2 className="h-3 w-3 animate-spin" /> : <Sparkles className="h-3 w-3" />}
                    Re-check
                  </Button>
                </div>
              </motion.div>
            ) : null}
          </AnimatePresence>
        </>
      )}
    </div>
  );
}

function RecruiterMatchPanel({
  matching,
  matches,
  expanded,
  onCheck,
  onToggle,
  onViewAll,
}: {
  matching: boolean;
  matches: RecruiterApplicantMatch[] | null;
  expanded: boolean;
  onCheck: () => void;
  onToggle: () => void;
  onViewAll: () => void;
}) {
  return (
    <div className="space-y-4 rounded-xl border bg-card p-5">
      <div className="flex items-center gap-2">
        <Sparkles className="h-4 w-4 text-primary" />
        <h2 className="font-display text-sm font-semibold text-foreground">AI candidate ranking</h2>
      </div>
      <p className="text-xs leading-5 text-muted-foreground">
        Run the real CV-to-JD matcher for applicants to this published role. Scores are returned without added noise.
      </p>
      <Button
        onClick={matches ? onToggle : onCheck}
        disabled={matching}
        variant="outline"
        className="w-full gap-2 border-primary/30 text-primary hover:bg-primary/10"
      >
        {matching ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
        {matching ? "Matching candidates..." : matches ? (expanded ? "Hide AI" : "Show AI") : "AI Suggestion"}
      </Button>
      {matches && expanded ? (
        <div className="space-y-3 border-t pt-4">
          {matches.length === 0 ? (
            <p className="text-xs text-muted-foreground">No applications are available to rank yet.</p>
          ) : matches.slice(0, 3).map((item, index) => (
            <div key={String(item.applicationId)} className="rounded-lg bg-primary/5 p-3">
              <div className="flex items-center justify-between gap-2">
                <p className="text-xs font-semibold text-foreground">
                  Rank {index + 1} · Candidate {ordinal(item.applicationOrder)}
                </p>
                <Badge className="bg-primary text-primary-foreground">{item.match.matchPercent ?? 0}%</Badge>
              </div>
              <p className="mt-1 line-clamp-2 text-[11px] leading-4 text-muted-foreground">{item.match.reason}</p>
            </div>
          ))}
          <div className="grid grid-cols-2 gap-2">
            <Button variant="ghost" size="sm" onClick={onCheck} disabled={matching}>Re-run</Button>
            <Button size="sm" onClick={onViewAll}>View ranking</Button>
          </div>
        </div>
      ) : null}
    </div>
  );
}

function ordinal(value: number) {
  const mod100 = value % 100;
  if (mod100 >= 11 && mod100 <= 13) return `${value}th`;
  if (value % 10 === 1) return `${value}st`;
  if (value % 10 === 2) return `${value}nd`;
  if (value % 10 === 3) return `${value}rd`;
  return `${value}th`;
}
