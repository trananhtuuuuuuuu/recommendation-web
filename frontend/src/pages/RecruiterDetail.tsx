import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import {
  AlertCircle,
  ArrowLeft,
  ArrowRight,
  Briefcase,
  Building2,
  Globe,
  Loader2,
  Mail,
  MapPin,
  Phone,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ApiError, resolveApiAssetUrl } from "@/lib/api";
import { fetchRecruiter, fetchRecruiterJobs, getJobId, getJobTitle, type Job, type Recruiter } from "@/lib/jobsApi";

export default function RecruiterDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [recruiter, setRecruiter] = useState<Recruiter | null>(null);
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    let active = true;
    setLoading(true);
    Promise.all([fetchRecruiter(id), fetchRecruiterJobs(id).catch(() => [])])
      .then(([recruiterData, jobsData]) => {
        if (!active) return;
        setRecruiter(recruiterData);
        setJobs(Array.isArray(jobsData) ? jobsData : []);
      })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load recruiter"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [id]);

  if (loading) {
    return <div className="text-center pt-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>;
  }

  if (error || !recruiter) {
    return (
      <div className="max-w-lg mx-auto pt-16 text-center space-y-3">
        <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
        <p className="text-sm text-foreground">{error ?? "Recruiter not found"}</p>
        <Button variant="outline" onClick={() => navigate(-1)}>Back</Button>
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="overflow-hidden rounded-xl border bg-card shadow-sm">
        <div className="relative h-44 bg-[linear-gradient(135deg,hsl(var(--primary)),hsl(var(--trust)),hsl(var(--accent)))] sm:h-56">
          {recruiter.coverImageUrl ? (
            <img src={resolveApiAssetUrl(recruiter.coverImageUrl)} alt={`${recruiter.companyName || "Company"} cover`} className="h-full w-full object-cover" />
          ) : null}
          <div className="absolute inset-0 bg-gradient-to-t from-foreground/25 to-transparent" />
        </div>
        <div className="relative flex flex-col gap-5 px-6 pb-6 sm:flex-row sm:items-end">
          <div className="-mt-14 flex h-28 w-28 shrink-0 items-center justify-center overflow-hidden rounded-2xl border-4 border-card bg-white p-1 shadow-md">
            {recruiter.logoUrl ? (
              <img src={resolveApiAssetUrl(recruiter.logoUrl)} alt={`${recruiter.companyName || "Company"} logo`} className="h-full w-full object-contain" />
            ) : (
              <Building2 className="w-9 h-9 text-primary" />
            )}
          </div>
          <div className="min-w-0 flex-1 pb-1">
            <div className="flex items-center gap-2 mb-1 flex-wrap">
              <h2 className="font-display text-xl font-bold text-foreground">{recruiter.companyName ?? recruiter.userName ?? "Recruiter"}</h2>
            </div>
            {recruiter.industry && <p className="text-sm text-muted-foreground mb-2">{recruiter.industry}</p>}
            <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
              {recruiter.email && <span className="flex items-center gap-1"><Mail className="w-3.5 h-3.5" /> {recruiter.email}</span>}
              {(recruiter.contactPhone || recruiter.phone) && <span className="flex items-center gap-1"><Phone className="w-3.5 h-3.5" /> {recruiter.contactPhone ?? recruiter.phone}</span>}
              {(recruiter.companyLocation || recruiter.address) && <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {recruiter.companyLocation ?? recruiter.address}</span>}
            </div>
          </div>
        </div>
      </motion.div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-2">About</h3>
        <p className="text-sm text-muted-foreground">{recruiter.companyDescription ?? "No company description yet."}</p>
        {recruiter.website && (
          <a href={recruiter.website} target="_blank" rel="noreferrer" className="inline-flex items-center gap-1 text-sm text-primary mt-3 hover:underline">
            <Globe className="w-3.5 h-3.5" /> {recruiter.website}
          </a>
        )}
      </div>

      <section className="glass-card rounded-xl p-6">
        <div className="flex flex-col justify-between gap-3 border-b border-border pb-4 sm:flex-row sm:items-end">
          <div>
            <h3 className="font-display font-semibold text-foreground">Open roles from this recruiter</h3>
            <p className="mt-1 text-xs text-muted-foreground">{jobs.length} job{jobs.length === 1 ? "" : "s"} loaded from the recruiter jobs API</p>
          </div>
          <Button size="sm" variant="outline" onClick={() => navigate("/jobs")}>Browse all jobs</Button>
        </div>
        {jobs.length > 0 ? (
          <div className="mt-4 grid gap-3 md:grid-cols-2">
            {jobs.slice(0, 4).map((job) => {
              const jobId = getJobId(job);
              return (
                <button
                  key={jobId}
                  type="button"
                  onClick={() => navigate(`/jobs/${jobId}`)}
                  className="group rounded-lg border bg-background p-4 text-left transition-colors hover:border-primary/30 hover:bg-primary/5"
                >
                  <div className="flex items-start justify-between gap-3">
                    <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary">
                      <Briefcase className="h-4 w-4" />
                    </span>
                    <ArrowRight className="h-4 w-4 text-muted-foreground transition-transform group-hover:translate-x-1 group-hover:text-primary" />
                  </div>
                  <h4 className="mt-3 font-display font-semibold text-foreground">{getJobTitle(job)}</h4>
                  <p className="mt-1 text-xs text-muted-foreground">
                    {[job.location, job.jobType, job.salaryRange].filter(Boolean).join(" · ") || "View role details"}
                  </p>
                </button>
              );
            })}
          </div>
        ) : (
          <div className="mt-4 rounded-lg border border-dashed p-8 text-center">
            <Briefcase className="mx-auto h-6 w-6 text-muted-foreground" />
            <p className="mt-2 text-sm text-muted-foreground">This recruiter has no current job listings.</p>
          </div>
        )}
      </section>
    </div>
  );
}
