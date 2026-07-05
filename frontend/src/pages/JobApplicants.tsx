import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, Users, Shield, Loader2, AlertCircle, Briefcase, Sparkles, Mail, Phone } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ApiError } from "@/lib/api";
import { fetchJob, fetchJobApplicantCount, fetchJobApplicants, type Job, type JobApplicant } from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";

interface Analysis { matchPercent: number; pros: string[]; cons: string[]; suggestions: string[] }

function applicantAnalysis(applicantName: string, jobTitle: string): Analysis {
  const seed = `${applicantName}-${jobTitle}`;
  const n = [...seed].reduce((sum, ch) => sum + ch.charCodeAt(0), 0);
  return {
    matchPercent: 55 + (n % 41),
    pros: ["Relevant profile keywords found", "Candidate details are complete enough for screening"],
    cons: ["CV depth cannot be fully verified by the demo AI", "Some job-specific requirements may need interview validation"],
    suggestions: ["Ask for one project aligned with this role", "Confirm availability and salary expectations early"],
  };
}

export default function JobApplicants() {
  const { jobId } = useParams();
  const navigate = useNavigate();
  const { user, role } = useAuth();
  const [job, setJob] = useState<Job | null>(null);
  const [count, setCount] = useState<number | null>(null);
  const [applicants, setApplicants] = useState<JobApplicant[]>([]);
  const [aiOpen, setAiOpen] = useState<Record<string, boolean>>({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!jobId) return;
    let active = true;
    setLoading(true);
    const recruiterId = role === "RECRUITER" ? user?.id : undefined;
    Promise.all([fetchJob(jobId), fetchJobApplicantCount(jobId), fetchJobApplicants(jobId, recruiterId)])
      .then(([jobData, countData, applicantData]) => {
        if (!active) return;
        setJob(jobData);
        setCount(typeof countData === "number" ? countData : countData?.applicantCount ?? countData?.count ?? 0);
        setApplicants(Array.isArray(applicantData) ? applicantData : []);
      })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load applicants"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [jobId, role, user?.id]);

  if (loading) {
    return <div className="text-center py-12"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>;
  }

  if (error || !job) {
    return (
      <div className="text-center py-20">
        <AlertCircle className="w-8 h-8 text-destructive mx-auto mb-3" />
        <p className="text-muted-foreground">{error ?? "Job not found."}</p>
        <Button variant="outline" className="mt-4" onClick={() => navigate("/jobs")}>Back to Jobs</Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={() => navigate("/jobs")}>
          <ArrowLeft className="w-4 h-4" />
        </Button>
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Applicants</h1>
          <p className="text-sm text-muted-foreground mt-0.5">
            Applicant summary for <span className="text-primary font-medium">{job.jobTitle ?? job.title}</span>
          </p>
        </div>
      </div>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center">
              <Users className="w-6 h-6 text-primary" />
            </div>
            <div>
              <p className="text-3xl font-bold text-foreground">{count ?? 0}</p>
              <p className="text-sm text-muted-foreground">applied applicant{count === 1 ? "" : "s"}</p>
            </div>
          </div>
          <Badge className="bg-primary/10 text-primary">
            <Shield className="w-3 h-3 mr-1" /> Count endpoint
          </Badge>
        </div>
      </motion.div>

      <div className="space-y-3">
        {applicants.length === 0 ? (
          <div className="glass-card rounded-xl p-6">
            <h2 className="font-display font-semibold text-foreground mb-2 flex items-center gap-2">
              <Briefcase className="w-4 h-4 text-primary" /> No Applications Yet
            </h2>
            <p className="text-sm text-muted-foreground">
              Saved jobs are not counted here. This view only shows applicants who submitted an application.
            </p>
          </div>
        ) : applicants.map((item) => {
          const applicant = item.applicant ?? {};
          const analysis = applicantAnalysis(applicant.fullName || applicant.userName || "Applicant", job.jobTitle ?? job.title ?? "Job");
          const itemKey = String(item.applicationId);
          const answers = parseAnswers(item.applicationAnswers);
          return (
            <motion.div key={String(item.applicationId)} initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-5 space-y-4">
              <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                <div>
                  <h2 className="font-display text-lg font-semibold text-foreground">{applicant.fullName || applicant.userName}</h2>
                  <div className="flex flex-wrap gap-3 text-xs text-muted-foreground mt-2">
                    {applicant.email && <span className="flex items-center gap-1"><Mail className="w-3 h-3" /> {applicant.email}</span>}
                    {applicant.phone && <span className="flex items-center gap-1"><Phone className="w-3 h-3" /> {applicant.phone}</span>}
                    {!applicant.email && !applicant.phone && (
                      <span>Contact fields hidden by candidate privacy settings.</span>
                    )}
                    {applicant.status && <Badge variant="outline">{applicant.status}</Badge>}
                  </div>
                </div>
                <div className="flex flex-wrap gap-2 sm:justify-end">
                  <Badge className="bg-primary/10 text-primary">
                    Applied
                  </Badge>
                </div>
              </div>
              {applicant.privacyNotice && (
                <div className="rounded-lg border bg-secondary/30 p-3 text-xs text-muted-foreground">
                  {applicant.privacyNotice}
                </div>
              )}
              <div className="grid md:grid-cols-[1fr_auto] gap-4 border-t border-border pt-4">
                <div className="space-y-2 text-xs text-muted-foreground">
                  {item.coverLetter && <p><span className="font-medium text-foreground">Cover letter:</span> {item.coverLetter}</p>}
                  {item.portfolioUrl && <p><span className="font-medium text-foreground">Portfolio:</span> {item.portfolioUrl}</p>}
                  {Object.entries(answers).slice(0, 4).map(([key, value]) => (
                    <p key={key}><span className="font-medium text-foreground">{humanize(key)}:</span> {String(value)}</p>
                  ))}
                </div>
                <div className="flex flex-wrap md:flex-col gap-2 md:items-end">
                  <Button size="sm" variant="outline" onClick={() => navigate(`/applicants/${applicant.id}`)}>View Profile</Button>
                  <Button size="sm" onClick={() => setAiOpen((current) => ({ ...current, [itemKey]: !current[itemKey] }))} className="gap-1">
                    <Sparkles className="w-3 h-3" /> {aiOpen[itemKey] ? "Hide AI" : "AI Suggestion"}
                  </Button>
                </div>
              </div>
              {aiOpen[itemKey] && (
                <div className="grid md:grid-cols-3 gap-4 rounded-lg border bg-primary/5 p-4">
                  <div>
                    <h3 className="text-xs font-semibold text-primary mb-2">{analysis.matchPercent}% Match</h3>
                    <p className="text-xs text-muted-foreground">Hardcoded demo AI suggestion based on applicant and job data.</p>
                  </div>
                  <Insight title="Pros" items={analysis.pros} />
                  <Insight title="Cons" items={analysis.cons} />
                  <Insight title="Suggestions" items={analysis.suggestions} />
                </div>
              )}
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}

function parseAnswers(raw?: string) {
  if (!raw) return {};
  try {
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === "object" ? parsed as Record<string, unknown> : {};
  } catch {
    return {};
  }
}

function humanize(value: string) {
  return value.replace(/_/g, " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function Insight({ title, items }: { title: string; items: string[] }) {
  return (
    <div>
      <h3 className="text-xs font-semibold text-foreground mb-2">{title}</h3>
      <ul className="space-y-1">
        {items.map((item) => <li key={item} className="text-xs text-muted-foreground">{item}</li>)}
      </ul>
    </div>
  );
}
