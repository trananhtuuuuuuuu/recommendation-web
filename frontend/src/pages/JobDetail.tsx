import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { motion } from "framer-motion";
import type { LucideIcon } from "lucide-react";
import {
  AlertCircle,
  ArrowLeft,
  Banknote,
  Bookmark,
  Briefcase,
  Building2,
  Calendar,
  Clock,
  Loader2,
  MapPin,
  ShieldCheck,
  Users,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  applyJob,
  fetchJob,
  fetchJobApplicantCount,
  getApplyingDeadline,
  saveJob,
  type ApplicationField,
  type Job,
  type JobApplicantsCount,
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
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);
  const [applied, setApplied] = useState(false);
  const [saving, setSaving] = useState(false);
  const [applying, setApplying] = useState(false);
  const [showApplyForm, setShowApplyForm] = useState(false);
  const [applicationAnswers, setApplicationAnswers] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!id) return;
    let active = true;
    setLoading(true);
    fetchJob(id)
      .then((j) => { if (active) setJob(j); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load job"); })
      .finally(() => { if (active) setLoading(false); });

    if (role === "RECRUITER" || role === "ADMIN") {
      fetchJobApplicantCount(id)
        .then((res) => {
          if (!active) return;
          const normalized = normalizeApplicantCount(res);
          setApplicantsCount(normalized);
        })
        .catch(() => { /* non-fatal */ });
    }
    return () => { active = false; };
  }, [id, role]);

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
              {(role === "RECRUITER" || role === "ADMIN") && id ? (
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
