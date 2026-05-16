import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, Users, Shield, Loader2, AlertCircle, Briefcase } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ApiError } from "@/lib/api";
import { fetchJob, fetchJobApplicantCount, type Job } from "@/lib/jobsApi";

export default function JobApplicants() {
  const { jobId } = useParams();
  const navigate = useNavigate();
  const [job, setJob] = useState<Job | null>(null);
  const [count, setCount] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!jobId) return;
    let active = true;
    setLoading(true);
    Promise.all([fetchJob(jobId), fetchJobApplicantCount(jobId)])
      .then(([jobData, countData]) => {
        if (!active) return;
        setJob(jobData);
        setCount(typeof countData === "number" ? countData : countData?.applicantCount ?? countData?.count ?? 0);
      })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load applicants"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [jobId]);

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
              <p className="text-sm text-muted-foreground">saved applicant relation{count === 1 ? "" : "s"}</p>
            </div>
          </div>
          <Badge className="bg-primary/10 text-primary">
            <Shield className="w-3 h-3 mr-1" /> Count endpoint
          </Badge>
        </div>
      </motion.div>

      <div className="glass-card rounded-xl p-6">
        <h2 className="font-display font-semibold text-foreground mb-2 flex items-center gap-2">
          <Briefcase className="w-4 h-4 text-primary" /> Backend Coverage
        </h2>
        <p className="text-sm text-muted-foreground">
          The current backend exposes an applicant count endpoint for a job. It does not yet expose a list of applicant profiles per job, so this page shows the available backend data without mock rows.
        </p>
      </div>
    </div>
  );
}
