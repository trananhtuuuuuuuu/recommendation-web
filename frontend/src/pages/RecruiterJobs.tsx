import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import {
  AlertCircle,
  Briefcase,
  Edit,
  Eye,
  FileCheck2,
  Inbox,
  Layers3,
  Loader2,
  Plus,
  Users,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { fetchRecruiterJobs, getJobId, getJobTitle, type Job } from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";
import MetricCard from "@/components/MetricCard";

export default function RecruiterJobs() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!user?.id) return;
    let active = true;
    fetchRecruiterJobs(user.id)
      .then((data) => { if (active) setJobs(Array.isArray(data) ? data : []); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load your jobs"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [user?.id]);

  const completeJobs = jobs.filter((job) =>
    Boolean(getJobTitle(job) && job.jobDescription && job.requirements && job.location)
  ).length;
  const jobsWithDeadline = jobs.filter((job) => job.applicationDeadline).length;
  const industryCount = new Set(jobs.map((job) => job.industry).filter(Boolean)).size;

  return (
    <div className="max-w-7xl mx-auto space-y-6 min-h-[calc(100vh-7rem)]">
      <div className="flex items-center justify-between flex-wrap gap-3 rounded-lg border bg-card p-5">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">My Posted Jobs</h1>
          <p className="text-sm text-muted-foreground mt-1">Manage your job postings</p>
        </div>
        <Button onClick={() => navigate("/recruiters/jobs/new")} className="gap-2 bg-primary text-primary-foreground">
          <Plus className="w-4 h-4" /> Post New Job
        </Button>
      </div>

      {loading && <div className="text-center text-sm text-muted-foreground py-8"><Loader2 className="w-5 h-5 animate-spin mx-auto" /></div>}

      {error && !loading && (
        <div className="glass-card rounded-xl p-8 text-center space-y-2">
          <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
          <p className="text-sm">{error}</p>
        </div>
      )}

      {!loading && !error && jobs.length === 0 && (
        <div className="glass-card rounded-xl p-10 text-center space-y-2">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <p className="text-sm text-muted-foreground">You haven't posted any jobs yet.</p>
          <Button size="sm" onClick={() => navigate("/recruiters/jobs/new")}>Post your first job</Button>
        </div>
      )}

      {!loading && !error && jobs.length > 0 && (
        <div className="grid sm:grid-cols-3 gap-4">
          <MetricCard icon={Briefcase} label="Published jobs" value={jobs.length} hint="Roles in your workspace" />
          <MetricCard icon={FileCheck2} label="Complete listings" value={`${completeJobs}/${jobs.length}`} hint="Core details provided" />
          <MetricCard icon={Layers3} label="Industries" value={industryCount || 1} hint={`${jobsWithDeadline} with deadlines`} />
        </div>
      )}

      <div className="grid lg:grid-cols-2 gap-4">
        {jobs.map((job, i) => {
          const id = getJobId(job);
          return (
            <motion.div key={id || i} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.04 }}
              className="rounded-lg border bg-card p-5 space-y-4">
              <div className="flex items-start justify-between gap-3">
                <div>
                <div className="flex items-center gap-2 mb-1">
                  <Briefcase className="w-4 h-4 text-primary" />
                  <h3 className="font-display font-semibold text-foreground">{getJobTitle(job)}</h3>
                </div>
                <p className="text-xs text-muted-foreground">
                  {job.location} · {job.jobType}
                  {job.postedDate ? ` · Posted ${job.postedDate}` : ""}
                </p>
                </div>
                {job.salaryRange && <span className="text-sm font-semibold text-foreground">{job.salaryRange}</span>}
              </div>
              {job.jobDescription && <p className="text-sm text-muted-foreground line-clamp-2">{job.jobDescription}</p>}
              <div className="flex gap-2 flex-wrap">
                <Button size="sm" variant="outline" onClick={() => navigate(`/jobs/${id}`)} className="gap-1"><Eye className="w-3 h-3" /> View</Button>
                <Button size="sm" variant="outline" onClick={() => navigate(`/recruiters/jobs/${id}/edit`)} className="gap-1"><Edit className="w-3 h-3" /> Edit</Button>
                <Button size="sm" variant="outline" onClick={() => navigate(`/jobs/${id}/applicants`)} className="gap-1"><Users className="w-3 h-3" /> Applicants</Button>
              </div>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
