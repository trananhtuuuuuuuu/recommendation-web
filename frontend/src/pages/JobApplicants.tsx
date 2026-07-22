import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, Users, Shield, Loader2, AlertCircle, Briefcase, Sparkles, Mail, Phone } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ApiError } from "@/lib/api";
import {
  fetchJob,
  fetchJobApplicantCount,
  fetchJobApplicants,
  matchRecruiterApplicants,
  type CvJobMatch,
  type Job,
  type JobApplicant,
  type RecruiterApplicantMatch,
} from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";

export default function JobApplicants() {
  const { jobId } = useParams();
  const navigate = useNavigate();
  const { user, role } = useAuth();
  const [job, setJob] = useState<Job | null>(null);
  const [count, setCount] = useState<number | null>(null);
  const [applicants, setApplicants] = useState<JobApplicant[]>([]);
  const [rankedMatches, setRankedMatches] = useState<RecruiterApplicantMatch[] | null>(null);
  const [aiOpen, setAiOpen] = useState<Record<string, boolean>>({});
  const [matching, setMatching] = useState(false);
  const [aiError, setAiError] = useState<string | null>(null);
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

  const handleAiMatch = async () => {
    if (!jobId || !user?.id || role !== "RECRUITER") return;
    setMatching(true);
    setAiError(null);
    try {
      const ranking = await matchRecruiterApplicants(user.id, jobId, { llm: false, method: "tfidf" });
      setRankedMatches(ranking);
      setAiOpen(Object.fromEntries(ranking.map((item) => [String(item.applicationId), true])));
    } catch (e) {
      setAiError(e instanceof ApiError ? e.message : "AI matching failed");
    } finally {
      setMatching(false);
    }
  };

  const visibleApplicants: JobApplicant[] = rankedMatches
    ? rankedMatches.map((item) => {
        const application = applicants.find((candidate) => String(candidate.applicationId) === String(item.applicationId));
        return {
          ...application,
          applicationId: item.applicationId,
          applicationOrder: item.applicationOrder,
          jobDescriptionId: jobId,
          applicant: item.applicant,
        };
      })
    : applicants;
  const matchByApplication = new Map(
    (rankedMatches ?? []).map((item) => [String(item.applicationId), item.match]),
  );

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

      <div className="flex flex-col justify-between gap-3 sm:flex-row sm:items-center">
        <div>
          <h2 className="font-display text-lg font-semibold text-foreground">Applied candidates</h2>
          <p className="text-xs text-muted-foreground">
            {rankedMatches ? "Ranked descending by the final AI match percentage." : "Ordered by application submission."}
          </p>
        </div>
        {role === "RECRUITER" && applicants.length > 0 ? (
          <Button onClick={handleAiMatch} disabled={matching} className="gap-2">
            {matching ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
            {matching ? "Matching candidates..." : rankedMatches ? "Re-run AI Match" : "AI Match"}
          </Button>
        ) : null}
      </div>
      {aiError ? (
        <div className="rounded-lg border border-destructive/30 bg-destructive/5 p-3 text-sm text-destructive">
          {aiError}
        </div>
      ) : null}

      <div className="space-y-3">
        {visibleApplicants.length === 0 ? (
          <div className="glass-card rounded-xl p-6">
            <h2 className="font-display font-semibold text-foreground mb-2 flex items-center gap-2">
              <Briefcase className="w-4 h-4 text-primary" /> No Applications Yet
            </h2>
            <p className="text-sm text-muted-foreground">
              Saved jobs are not counted here. This view only shows applicants who submitted an application.
            </p>
          </div>
        ) : visibleApplicants.map((item, visibleIndex) => {
          const applicant = item.applicant ?? {};
          const itemKey = String(item.applicationId);
          const match = matchByApplication.get(itemKey);
          const applicationOrder = item.applicationOrder ?? visibleIndex + 1;
          const candidateLabel = `Candidate ${ordinal(applicationOrder)}`;
          const sharedName = applicant.fullName && applicant.fullName !== "Candidate" ? applicant.fullName : null;
          const answers = parseAnswers(item.applicationAnswers);
          return (
            <motion.div key={String(item.applicationId)} initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-5 space-y-4">
              <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                <div>
                  <h2 className="font-display text-lg font-semibold text-foreground">
                    {candidateLabel}{sharedName ? ` · ${sharedName}` : ""}
                  </h2>
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
                  {match ? <MatchBadge match={match} rank={visibleIndex + 1} /> : null}
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
                  {match ? (
                    <Button size="sm" onClick={() => setAiOpen((current) => ({ ...current, [itemKey]: !current[itemKey] }))} className="gap-1">
                      <Sparkles className="w-3 h-3" /> {aiOpen[itemKey] ? "Hide AI details" : "Show AI details"}
                    </Button>
                  ) : null}
                </div>
              </div>
              {match && aiOpen[itemKey] ? <MatchDetails match={match} /> : null}
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

function MatchBadge({ match, rank }: { match: CvJobMatch; rank: number }) {
  const percent = match.matchPercent ?? Math.round((match.matchScore ?? 0) * 100);
  return (
    <Badge className="bg-primary text-primary-foreground">
      Rank {rank} · {percent}% match
    </Badge>
  );
}

function MatchDetails({ match }: { match: CvJobMatch }) {
  const percent = match.matchPercent ?? Math.round((match.matchScore ?? 0) * 100);
  const fieldScores = Object.entries(match.perFieldScores ?? {}).sort(([, left], [, right]) => right - left);
  return (
    <div className="grid gap-4 rounded-lg border bg-primary/5 p-4 md:grid-cols-2">
      <div>
        <h3 className="text-sm font-semibold text-primary">{percent}% final match</h3>
        <p className="mt-2 text-xs leading-5 text-muted-foreground">{match.reason || "No AI explanation was returned."}</p>
        {match.hardFilterReasons && match.hardFilterReasons.length > 0 ? (
          <ul className="mt-3 space-y-1 text-xs text-destructive">
            {match.hardFilterReasons.map((reason) => <li key={reason}>• {reason}</li>)}
          </ul>
        ) : null}
      </div>
      <div className="space-y-2">
        <h3 className="text-xs font-semibold text-foreground">Field scores</h3>
        {fieldScores.length > 0 ? fieldScores.map(([field, score]) => (
          <div key={field}>
            <div className="mb-1 flex justify-between text-[11px] text-muted-foreground">
              <span>{humanize(field)}</span><span>{Math.round(score * 100)}%</span>
            </div>
            <div className="h-1.5 overflow-hidden rounded-full bg-secondary">
              <div className="h-full rounded-full bg-primary" style={{ width: `${Math.round(score * 100)}%` }} />
            </div>
          </div>
        )) : <p className="text-xs text-muted-foreground">No per-field scores available.</p>}
      </div>
      {match.suggestions && match.suggestions.length > 0 ? (
        <div className="md:col-span-2">
          <h3 className="text-xs font-semibold text-foreground">AI suggestions</h3>
          <ul className="mt-2 space-y-1">
            {match.suggestions.map((suggestion) => <li key={suggestion} className="text-xs text-muted-foreground">• {suggestion}</li>)}
          </ul>
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
