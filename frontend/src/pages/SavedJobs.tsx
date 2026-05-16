import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { Bookmark, Briefcase, MapPin, Loader2, AlertCircle, Inbox } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { fetchSavedJobs, getJobId, getJobTitle, type Job } from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";

export default function SavedJobs() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!user?.id) return;
    fetchSavedJobs(user.id)
      .then((d) => setJobs(Array.isArray(d) ? d : []))
      .catch((e) => setError(e instanceof ApiError ? e.message : "Failed to load saved jobs"))
      .finally(() => setLoading(false));
  }, [user?.id]);

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div>
        <h1 className="font-display text-2xl font-bold text-foreground flex items-center gap-2">
          <Bookmark className="w-6 h-6 text-primary" /> Saved Jobs
        </h1>
        <p className="text-sm text-muted-foreground mt-1">Jobs you've bookmarked</p>
      </div>

      {loading && <div className="text-center py-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>}
      {error && !loading && (
        <div className="glass-card rounded-xl p-8 text-center space-y-2">
          <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
          <p className="text-sm">{error}</p>
        </div>
      )}
      {!loading && !error && jobs.length === 0 && (
        <div className="glass-card rounded-xl p-10 text-center space-y-2">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <p className="text-sm text-muted-foreground">No saved jobs yet.</p>
          <Button size="sm" onClick={() => navigate("/jobs")}>Browse jobs</Button>
        </div>
      )}

      <div className="space-y-3">
        {jobs.map((job, i) => {
          const id = getJobId(job);
          return (
            <motion.div key={id || i} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.04 }}
              className="glass-card rounded-xl p-5 flex items-center justify-between flex-wrap gap-3">
              <div>
                <h3 className="font-display font-semibold text-foreground">{getJobTitle(job)}</h3>
                <div className="flex flex-wrap items-center gap-3 text-xs text-muted-foreground mt-1">
                  {job.companyName && <span className="flex items-center gap-1"><Briefcase className="w-3 h-3" /> {job.companyName}</span>}
                  {job.location && <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {job.location}</span>}
                </div>
              </div>
              <div className="flex items-center gap-2">
                {job.salaryRange && <p className="font-display font-semibold text-foreground text-sm mr-2">{job.salaryRange}</p>}
                <Button size="sm" variant="outline" onClick={() => navigate(`/jobs/${id}`)}>View</Button>
              </div>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
