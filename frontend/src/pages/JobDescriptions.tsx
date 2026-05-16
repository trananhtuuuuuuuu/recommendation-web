import { useEffect, useState } from "react";
import { Plus, Edit, Eye, Users, Calendar, CheckCircle, Loader2, AlertCircle, Inbox } from "lucide-react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ApiError } from "@/lib/api";
import { fetchJobs, getJobId, getJobTitle, type Job } from "@/lib/jobsApi";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";

export default function JobDescriptions() {
  const navigate = useNavigate();
  const { role } = useAuth();
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    fetchJobs()
      .then((data) => { if (active) setJobs(Array.isArray(data) ? data : []); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load job descriptions"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, []);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between gap-3 flex-wrap">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Job Descriptions</h1>
          <p className="text-sm text-muted-foreground mt-1">Current job postings from the backend</p>
        </div>
        {role === "RECRUITER" && (
          <Button onClick={() => navigate("/recruiters/jobs/new")} className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2">
            <Plus className="w-4 h-4" /> New JD
          </Button>
        )}
      </div>

      {loading && <div className="text-center py-10"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>}

      {error && !loading && (
        <div className="glass-card rounded-xl p-8 text-center space-y-2">
          <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
          <p className="text-sm">{error}</p>
        </div>
      )}

      {!loading && !error && jobs.length === 0 && (
        <div className="glass-card rounded-xl p-10 text-center space-y-2">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <p className="text-sm text-muted-foreground">No job descriptions found.</p>
        </div>
      )}

      <div className="grid gap-4">
        {jobs.map((job, i) => {
          const id = getJobId(job);
          return (
            <motion.div
              key={id || i}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.04 }}
              className="glass-card rounded-xl p-5"
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1 flex-wrap">
                    <h3 className="font-display font-semibold text-foreground">{getJobTitle(job)}</h3>
                    <Badge className="text-[10px] bg-success/10 text-success">
                      <CheckCircle className="w-3 h-3 mr-1" /> Active
                    </Badge>
                  </div>
                  <p className="text-sm text-muted-foreground mb-3 line-clamp-2">
                    {job.aboutCompany || job.jobDescription || "No description provided."}
                  </p>
                  <div className="flex flex-wrap gap-4 text-xs text-muted-foreground">
                    {job.recruiterName && <span>{job.recruiterName}</span>}
                    <span className="flex items-center gap-1"><Users className="w-3 h-3" /> Applicants API available</span>
                    {(job.startDate || job.endDate) && (
                      <span className="flex items-center gap-1"><Calendar className="w-3 h-3" /> {job.startDate ?? "N/A"} - {job.endDate ?? "N/A"}</span>
                    )}
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <Button variant="outline" size="sm" className="gap-1" onClick={() => navigate(`/jobs/${id}`)}><Eye className="w-3 h-3" /> View</Button>
                  {role === "RECRUITER" && (
                    <Button variant="outline" size="sm" className="gap-1" onClick={() => navigate(`/recruiters/jobs/${id}/edit`)}><Edit className="w-3 h-3" /> Edit</Button>
                  )}
                </div>
              </div>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
