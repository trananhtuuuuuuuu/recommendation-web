import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { motion } from "framer-motion";
import { Briefcase, MapPin, Clock, Users, ArrowLeft, Bookmark, Loader2, AlertCircle, Calendar } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { applyJob, fetchJob, fetchJobApplicantCount, saveJob, type ApplicationField, type Job } from "@/lib/jobsApi";
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
          const normalized = typeof res === "number" ? res : (res as any)?.applicantCount ?? (res as any)?.count ?? null;
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
  const handleApply = async () => {
    if (!isAuthenticated) { navigate("/auth"); return; }
    if (role !== "APPLICANT") { toast.error("Only applicants can apply for jobs."); return; }
    if (!user?.id || !id) return;
    const missing = customFields.find((field) => field.required && !applicationAnswers[field.id]?.trim());
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
    <div className="max-w-4xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6 space-y-4">
        <div className="flex items-start justify-between flex-wrap gap-4">
          <div>
            <h1 className="font-display text-2xl font-bold text-foreground mb-2">
              {job.jobTitle || job.title}
            </h1>
            <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
              {job.companyName && <span className="flex items-center gap-1"><Briefcase className="w-3.5 h-3.5" /> {job.companyName}</span>}
              {job.location && <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {job.location}</span>}
              {job.postedDate && <span className="flex items-center gap-1"><Clock className="w-3.5 h-3.5" /> {job.postedDate}</span>}
              {applicantsCount !== null && (
                <Badge className="bg-primary/10 text-primary text-[10px]">
                  <Users className="w-3 h-3 mr-1" /> {applicantsCount} applicants
                </Badge>
              )}
            </div>
          </div>
          <div className="text-right">
            {job.salaryRange && <p className="font-display font-semibold text-foreground">{job.salaryRange}</p>}
              {job.jobType && <p className="text-xs text-muted-foreground mb-2">{job.jobType}</p>}
            {job.recruiterId && (
              <Button size="sm" variant="ghost" onClick={() => navigate(`/recruiters/${job.recruiterId}`)}>
                Recruiter Profile
              </Button>
            )}
            {role === "APPLICANT" && (
              <div className="flex flex-wrap justify-end gap-2">
                <Button size="sm" onClick={() => setShowApplyForm(true)} disabled={applied} className="gap-1">
                  <Briefcase className="w-3.5 h-3.5" />
                  {applied ? "Applied" : "Apply"}
                </Button>
                <Button size="sm" variant="outline" onClick={handleSave} disabled={saving} className="gap-1">
                  {saving ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> :
                    <Bookmark className={`w-3.5 h-3.5 ${saved ? "fill-primary text-primary" : ""}`} />}
                  {saved ? "Saved" : "Save"}
                </Button>
              </div>
            )}
          </div>
        </div>

        {job.aboutCompany && (
          <Section title="About the company"><p className="text-sm text-muted-foreground">{job.aboutCompany}</p></Section>
        )}
        {(job.jobDescription || job.description) && (
          <Section title="Description">
            <p className="text-sm text-muted-foreground whitespace-pre-line">{job.jobDescription || job.description}</p>
          </Section>
        )}
        {job.requirements && (
          <Section title="Requirements">
            <p className="text-sm text-muted-foreground whitespace-pre-line">{job.requirements}</p>
          </Section>
        )}
        {job.benefits && (
          <Section title="Benefits">
            <p className="text-sm text-muted-foreground whitespace-pre-line">{job.benefits}</p>
          </Section>
        )}

        <div className="flex flex-wrap gap-4 text-xs text-muted-foreground pt-2 border-t border-border">
          {job.experienceLevel && <span>Level: <span className="text-foreground">{job.experienceLevel}</span></span>}
          {job.industry && <span>Industry: <span className="text-foreground">{job.industry}</span></span>}
          {job.applicationDeadline && (
            <span className="flex items-center gap-1"><Calendar className="w-3 h-3" /> Deadline: {job.applicationDeadline}</span>
          )}
          {job.startDate && <span>Start: {job.startDate}</span>}
          {job.endDate && <span>End: {job.endDate}</span>}
        </div>
      </motion.div>

      {showApplyForm && (
        <div className="fixed inset-0 z-50 bg-foreground/40 flex items-start justify-center p-4 pt-12 overflow-y-auto" onClick={(event) => event.target === event.currentTarget && setShowApplyForm(false)}>
          <div className="w-full max-w-2xl rounded-lg border bg-background p-6 shadow-xl space-y-5">
            <div>
              <h2 className="font-display text-xl font-bold text-foreground">Apply for {job.jobTitle || job.title}</h2>
              <p className="text-sm text-muted-foreground mt-1">Your saved CV/profile will be attached. Complete the recruiter questions before submitting.</p>
            </div>
            <div className="space-y-4">
              {(customFields.length > 0 ? customFields : defaultApplicationFields).map((field) => (
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
