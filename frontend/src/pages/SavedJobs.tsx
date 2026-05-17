import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { Bookmark, Briefcase, MapPin, Loader2, AlertCircle, Inbox, Send } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { fetchAppliedJobs, fetchSavedJobs, getJobId, type SavedJob } from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";

export default function SavedJobs() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [jobs, setJobs] = useState<SavedJob[]>([]);
  const [appliedJobs, setAppliedJobs] = useState<SavedJob[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!user?.id) return;
    Promise.all([fetchSavedJobs(user.id), fetchAppliedJobs(user.id)])
      .then(([saved, applied]) => {
        setJobs(Array.isArray(saved) ? saved : []);
        setAppliedJobs(Array.isArray(applied) ? applied : []);
      })
      .catch((e) => setError(e instanceof ApiError ? e.message : "Failed to load saved jobs"))
      .finally(() => setLoading(false));
  }, [user?.id]);

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div>
        <h1 className="font-display text-2xl font-bold text-foreground flex items-center gap-2">
          <Bookmark className="w-6 h-6 text-primary" /> My Jobs
        </h1>
        <p className="text-sm text-muted-foreground mt-1">Track jobs you saved and applications you submitted</p>
      </div>

      {loading && <div className="text-center py-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>}
      {error && !loading && (
        <div className="glass-card rounded-xl p-8 text-center space-y-2">
          <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
          <p className="text-sm">{error}</p>
        </div>
      )}
      {!loading && !error && jobs.length === 0 && appliedJobs.length === 0 && (
        <div className="glass-card rounded-xl p-10 text-center space-y-2">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <p className="text-sm text-muted-foreground">No saved or applied jobs yet.</p>
          <Button size="sm" onClick={() => navigate("/jobs")}>Browse jobs</Button>
        </div>
      )}

      {!loading && !error && (
        <div className="grid lg:grid-cols-2 gap-5">
          <JobSection title="Applied Jobs" icon={<Send className="w-5 h-5 text-primary" />} jobs={appliedJobs} empty="No applications submitted yet." navigate={navigate} />
          <JobSection title="Saved Jobs" icon={<Bookmark className="w-5 h-5 text-primary" />} jobs={jobs} empty="No saved jobs yet." navigate={navigate} />
        </div>
      )}
    </div>
  );
}

function JobSection({
  title,
  icon,
  jobs,
  empty,
  navigate,
}: {
  title: string;
  icon: React.ReactNode;
  jobs: SavedJob[];
  empty: string;
  navigate: (to: string) => void;
}) {
  return (
    <section className="rounded-lg border bg-card p-5 min-h-[360px]">
      <div className="flex items-center justify-between mb-4">
        <h2 className="font-display font-semibold text-foreground flex items-center gap-2">{icon} {title}</h2>
        <span className="text-xs text-muted-foreground">{jobs.length} total</span>
      </div>
      {jobs.length === 0 ? (
        <div className="h-56 flex flex-col items-center justify-center text-center gap-2 text-muted-foreground">
          <Inbox className="w-7 h-7" />
          <p className="text-sm">{empty}</p>
        </div>
      ) : (
        <div className="space-y-3">
          {jobs.map((job, i) => {
            const id = getJobId(job);
            return (
              <motion.div key={id || i} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.04 }}
                className="rounded-lg border bg-background p-4 flex items-center justify-between flex-wrap gap-3">
                <div>
                  <h3 className="font-display font-semibold text-foreground">{job.jobTitle ?? "Untitled"}</h3>
                  <div className="flex flex-wrap items-center gap-3 text-xs text-muted-foreground mt-1">
                    {job.companyName && <span className="flex items-center gap-1"><Briefcase className="w-3 h-3" /> {job.companyName}</span>}
                    {job.location && <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {job.location}</span>}
                  </div>
                </div>
                <Button size="sm" variant="outline" onClick={() => navigate(`/jobs/${id}`)}>View</Button>
              </motion.div>
            );
          })}
        </div>
      )}
    </section>
  );
}
