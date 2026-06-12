import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import {
  AlertCircle,
  Bookmark,
  Briefcase,
  CheckCircle2,
  Eye,
  Inbox,
  ListChecks,
  Loader2,
  MapPin,
  Send,
  Trash2,
  Undo2,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import {
  fetchAppliedJobs,
  fetchSavedJobs,
  getJobId,
  removeSavedJob,
  withdrawApplication,
  type SavedJob,
} from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";
import MetricCard from "@/components/MetricCard";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { toast } from "sonner";

type JobCollection = "saved" | "applied";

interface PendingRemoval {
  collection: JobCollection;
  job: SavedJob;
}

export default function SavedJobs() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [jobs, setJobs] = useState<SavedJob[]>([]);
  const [appliedJobs, setAppliedJobs] = useState<SavedJob[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [pendingRemoval, setPendingRemoval] = useState<PendingRemoval | null>(null);
  const [removingKey, setRemovingKey] = useState<string | null>(null);

  useEffect(() => {
    if (!user?.id) return;
    Promise.all([fetchSavedJobs(user.id), fetchAppliedJobs(user.id)])
      .then(([saved, applied]) => {
        setJobs(Array.isArray(saved) ? saved : []);
        setAppliedJobs(Array.isArray(applied) ? applied : []);
      })
      .catch((e) => setError(e instanceof ApiError ? e.message : "Failed to load your jobs"))
      .finally(() => setLoading(false));
  }, [user?.id]);

  const handleConfirmRemoval = async () => {
    if (!pendingRemoval || !user?.id) return;

    const applicantJobId = pendingRemoval.job.applicantJobId;
    if (applicantJobId === undefined || applicantJobId === null) {
      toast.error("This job record is missing its relation ID.");
      return;
    }

    const relationId = String(applicantJobId);
    const key = `${pendingRemoval.collection}:${relationId}`;
    setRemovingKey(key);

    try {
      if (pendingRemoval.collection === "saved") {
        await removeSavedJob(user.id, relationId);
        setJobs((currentJobs) => currentJobs.filter(
          (job) => String(job.applicantJobId) !== relationId,
        ));
        toast.success("Job removed from saved jobs.");
      } else {
        await withdrawApplication(user.id, relationId);
        setAppliedJobs((currentJobs) => currentJobs.filter(
          (job) => String(job.applicantJobId) !== relationId,
        ));
        toast.success("Application withdrawn.");
      }
      setPendingRemoval(null);
    } catch (removalError) {
      toast.error(removalError instanceof ApiError ? removalError.message : "Unable to update this job.");
    } finally {
      setRemovingKey(null);
    }
  };

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
        <div className="glass-card rounded-xl p-10 text-center space-y-3">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <div>
            <h2 className="font-display font-semibold text-foreground">Start your job shortlist</h2>
            <p className="mt-1 text-sm text-muted-foreground">Save roles for later or submit an application to begin tracking progress here.</p>
          </div>
          <Button size="sm" onClick={() => navigate("/jobs")}>Browse jobs</Button>
        </div>
      )}

      {!loading && !error && jobs.length + appliedJobs.length > 0 ? (
        <>
          <div className="grid grid-cols-2 gap-3 lg:grid-cols-3">
            <MetricCard icon={ListChecks} label="Tracked roles" value={jobs.length + appliedJobs.length} hint="Saved and applied" />
            <MetricCard icon={Send} label="Applications" value={appliedJobs.length} hint="Submitted roles" />
            <MetricCard icon={Bookmark} label="Saved for later" value={jobs.length} hint="Your shortlist" className="col-span-2 lg:col-span-1" />
          </div>
          <div className="grid gap-5 lg:grid-cols-2">
            <JobSection
              title="Applied Jobs"
              icon={<Send className="w-5 h-5 text-primary" />}
              jobs={appliedJobs}
              empty="No applications submitted yet."
              collection="applied"
              navigate={navigate}
              removingKey={removingKey}
              onRequestRemoval={(job) => setPendingRemoval({ collection: "applied", job })}
            />
            <JobSection
              title="Saved Jobs"
              icon={<Bookmark className="w-5 h-5 text-primary" />}
              jobs={jobs}
              empty="No saved jobs yet."
              collection="saved"
              navigate={navigate}
              removingKey={removingKey}
              onRequestRemoval={(job) => setPendingRemoval({ collection: "saved", job })}
            />
          </div>
        </>
      ) : null}

      {!loading && !error ? (
        <section className="rounded-xl border bg-card p-5">
          <div className="flex flex-col justify-between gap-4 sm:flex-row sm:items-center">
            <div>
              <h2 className="font-display font-semibold text-foreground">Keep your application workflow moving</h2>
              <p className="mt-1 text-sm text-muted-foreground">A complete profile makes the apply step faster and gives recruiters better context.</p>
            </div>
            <Button variant="outline" size="sm" onClick={() => navigate("/profiles")}>Review profile</Button>
          </div>
          <div className="mt-5 grid gap-3 sm:grid-cols-3">
            {[
              { icon: Bookmark, label: "Shortlist", text: "Save roles worth comparing." },
              { icon: Eye, label: "Review", text: "Check requirements and deadlines." },
              { icon: CheckCircle2, label: "Apply", text: "Submit answers and track progress." },
            ].map(({ icon: Icon, label, text }) => (
              <div key={label} className="flex gap-3 rounded-lg bg-secondary/50 p-3">
                <Icon className="mt-0.5 h-4 w-4 shrink-0 text-primary" />
                <div>
                  <p className="text-sm font-medium text-foreground">{label}</p>
                  <p className="mt-0.5 text-xs text-muted-foreground">{text}</p>
                </div>
              </div>
            ))}
          </div>
        </section>
      ) : null}

      <AlertDialog
        open={pendingRemoval !== null}
        onOpenChange={(open) => {
          if (!open && !removingKey) setPendingRemoval(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>
              {pendingRemoval?.collection === "applied" ? "Withdraw this application?" : "Remove this saved job?"}
            </AlertDialogTitle>
            <AlertDialogDescription>
              {pendingRemoval?.collection === "applied"
                ? `Your application for ${pendingRemoval.job.jobTitle ?? "this job"} will be withdrawn and removed from your applied jobs.`
                : `${pendingRemoval?.job.jobTitle ?? "This job"} will be removed from your saved list. You can save it again later.`}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={Boolean(removingKey)}>Keep it</AlertDialogCancel>
            <AlertDialogAction
              disabled={Boolean(removingKey)}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={(event) => {
                event.preventDefault();
                void handleConfirmRemoval();
              }}
            >
              {removingKey ? <Loader2 className="h-4 w-4 animate-spin" /> : null}
              {pendingRemoval?.collection === "applied" ? "Withdraw application" : "Remove saved job"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

function JobSection({
  title,
  icon,
  jobs,
  empty,
  collection,
  navigate,
  removingKey,
  onRequestRemoval,
}: {
  title: string;
  icon: React.ReactNode;
  jobs: SavedJob[];
  empty: string;
  collection: JobCollection;
  navigate: (to: string) => void;
  removingKey: string | null;
  onRequestRemoval: (job: SavedJob) => void;
}) {
  return (
    <section className="rounded-lg border bg-card p-5">
      <div className="flex items-center justify-between mb-4">
        <h2 className="font-display font-semibold text-foreground flex items-center gap-2">{icon} {title}</h2>
        <span className="text-xs text-muted-foreground">{jobs.length} total</span>
      </div>
      {jobs.length === 0 ? (
        <div className="flex min-h-36 flex-col items-center justify-center gap-2 text-center text-muted-foreground">
          <Inbox className="w-7 h-7" />
          <p className="text-sm">{empty}</p>
        </div>
      ) : (
        <div className="space-y-3">
          {jobs.map((job, i) => {
            const id = getJobId(job);
            const relationId = job.applicantJobId === undefined || job.applicantJobId === null
              ? ""
              : String(job.applicantJobId);
            const isRemoving = removingKey === `${collection}:${relationId}`;
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
                <div className="flex flex-wrap gap-2">
                  <Button size="sm" variant="outline" onClick={() => navigate(`/jobs/${id}`)}>View</Button>
                  <Button
                    size="sm"
                    variant={collection === "applied" ? "destructive" : "outline"}
                    disabled={!relationId || isRemoving}
                    className={collection === "saved" ? "gap-1.5 text-destructive hover:bg-destructive/10 hover:text-destructive" : "gap-1.5"}
                    onClick={() => onRequestRemoval(job)}
                  >
                    {isRemoving ? (
                      <Loader2 className="h-3.5 w-3.5 animate-spin" />
                    ) : collection === "applied" ? (
                      <Undo2 className="h-3.5 w-3.5" />
                    ) : (
                      <Trash2 className="h-3.5 w-3.5" />
                    )}
                    {collection === "applied" ? "Withdraw" : "Remove"}
                  </Button>
                </div>
              </motion.div>
            );
          })}
        </div>
      )}
    </section>
  );
}
