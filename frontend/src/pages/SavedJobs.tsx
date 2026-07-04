import { type KeyboardEvent, useCallback, useEffect, useMemo, useRef, useState } from "react";
import { motion } from "framer-motion";
import {
  AlertCircle,
  Bookmark,
  Briefcase,
  Calendar,
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
import { useNavigate } from "react-router-dom";
import { toast } from "sonner";
import { ApiError } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import {
  fetchAppliedJobs,
  fetchSavedJobs,
  getJobId,
  removeSavedJob,
  withdrawApplication,
  type PageResponse,
  type SavedJob,
} from "@/lib/jobsApi";
import MetricCard from "@/components/MetricCard";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
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

type JobCollection = "applied" | "saved";

interface PendingRemoval {
  collection: JobCollection;
  job: SavedJob;
}

const PAGE_SIZE = 5;

const emptyPage: PageResponse<SavedJob> = {
  content: [],
  page: 0,
  size: PAGE_SIZE,
  totalElements: 0,
  totalPages: 0,
  first: true,
  last: true,
};

export default function SavedJobs() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState<JobCollection>("applied");
  const [pages, setPages] = useState<Record<JobCollection, number>>({ applied: 0, saved: 0 });
  const [data, setData] = useState<Record<JobCollection, PageResponse<SavedJob> | null>>({
    applied: null,
    saved: null,
  });
  const [loading, setLoading] = useState(false);
  const [summaryLoading, setSummaryLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [retryKey, setRetryKey] = useState(0);
  const [pendingRemoval, setPendingRemoval] = useState<PendingRemoval | null>(null);
  const [removingKey, setRemovingKey] = useState<string | null>(null);
  const requestId = useRef(0);

  const activePage = pages[activeTab];
  const activeData = data[activeTab] ?? emptyPage;
  const appliedCount = data.applied?.totalElements ?? 0;
  const savedCount = data.saved?.totalElements ?? 0;

  const loadPage = useCallback(
    (collection: JobCollection, page: number, size = PAGE_SIZE) => {
      if (!user?.id) return Promise.resolve(emptyPage);
      const fetcher = collection === "applied" ? fetchAppliedJobs : fetchSavedJobs;
      return fetcher(user.id, page, size);
    },
    [user?.id],
  );

  useEffect(() => {
    if (!user?.id) return;
    const currentRequest = requestId.current + 1;
    requestId.current = currentRequest;
    setLoading(true);
    setError(null);

    loadPage(activeTab, activePage)
      .then((pageData) => {
        if (requestId.current !== currentRequest) return;
        setData((current) => ({ ...current, [activeTab]: pageData }));
      })
      .catch((e) => {
        if (requestId.current !== currentRequest) return;
        setError(e instanceof ApiError ? e.message : "Failed to load your jobs");
      })
      .finally(() => {
        if (requestId.current === currentRequest) setLoading(false);
      });
  }, [activePage, activeTab, loadPage, retryKey, user?.id]);

  useEffect(() => {
    if (!user?.id) return;
    const otherTab: JobCollection = activeTab === "applied" ? "saved" : "applied";
    if (data[otherTab] !== null) return;

    let alive = true;
    setSummaryLoading(true);
    loadPage(otherTab, 0, 1)
      .then((pageData) => {
        if (alive) setData((current) => ({ ...current, [otherTab]: pageData }));
      })
      .catch(() => {
        if (alive) setData((current) => ({ ...current, [otherTab]: emptyPage }));
      })
      .finally(() => {
        if (alive) setSummaryLoading(false);
      });
    return () => {
      alive = false;
    };
  }, [activeTab, data, loadPage, user?.id]);

  const totals = useMemo(
    () => ({
      tracked: appliedCount + savedCount,
      applied: appliedCount,
      saved: savedCount,
    }),
    [appliedCount, savedCount],
  );

  const handleTabChange = (value: string) => {
    const nextTab = value as JobCollection;
    setActiveTab(nextTab);
    setPages((current) => ({ ...current, [nextTab]: 0 }));
  };

  const refreshActivePage = () => setRetryKey((current) => current + 1);

  const handleConfirmRemoval = async () => {
    if (!pendingRemoval || !user?.id) return;

    const applicantJobId = pendingRemoval.job.applicantJobId;
    if (applicantJobId === undefined || applicantJobId === null) {
      toast.error("This job record is missing its relation ID.");
      return;
    }

    const relationId = String(applicantJobId);
    const collection = pendingRemoval.collection;
    const key = `${collection}:${relationId}`;
    setRemovingKey(key);

    try {
      if (collection === "saved") {
        await removeSavedJob(user.id, relationId);
        toast.success("Job removed from saved jobs.");
      } else {
        await withdrawApplication(user.id, relationId);
        toast.success("Application withdrawn.");
      }

      setPendingRemoval(null);
      const currentPageData = data[collection] ?? emptyPage;
      const nextTotal = Math.max(currentPageData.totalElements - 1, 0);
      const nextLastPage = Math.max(Math.ceil(nextTotal / PAGE_SIZE) - 1, 0);
      setData((current) => ({
        ...current,
        [collection]: {
          ...(current[collection] ?? emptyPage),
          totalElements: nextTotal,
          totalPages: nextTotal === 0 ? 0 : Math.ceil(nextTotal / PAGE_SIZE),
        },
      }));

      if (pages[collection] > nextLastPage) {
        setPages((current) => ({ ...current, [collection]: nextLastPage }));
      } else if (collection === activeTab) {
        refreshActivePage();
      } else {
        setData((current) => ({ ...current, [collection]: null }));
      }
    } catch (removalError) {
      toast.error(removalError instanceof ApiError ? removalError.message : "Unable to update this job.");
    } finally {
      setRemovingKey(null);
    }
  };

  return (
    <div className="mx-auto max-w-6xl space-y-6">
      <div>
        <h1 className="font-display flex items-center gap-2 text-2xl font-bold text-foreground">
          <Bookmark className="h-6 w-6 text-primary" /> My Jobs
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">Track jobs you saved and applications you submitted</p>
      </div>

      <div className="grid grid-cols-2 gap-3 lg:grid-cols-3">
        <MetricCard icon={ListChecks} label="Tracked roles" value={totals.tracked} hint="Saved and applied" />
        <MetricCard icon={Send} label="Applications" value={totals.applied} hint="Submitted roles" />
        <MetricCard icon={Bookmark} label="Saved for later" value={totals.saved} hint="Your shortlist" className="col-span-2 lg:col-span-1" />
      </div>

      <section className="rounded-lg border bg-card p-4">
        <div
          role="tablist"
          aria-label="Applicant job lists"
          className="grid w-full grid-cols-2 rounded-md bg-muted p-1 text-muted-foreground sm:inline-grid sm:w-auto"
        >
          <button
            type="button"
            role="tab"
            id="applied-jobs-tab"
            aria-selected={activeTab === "applied"}
            aria-controls="applied-jobs-panel"
            tabIndex={activeTab === "applied" ? 0 : -1}
            className="inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 aria-selected:bg-background aria-selected:text-foreground aria-selected:shadow-sm"
            onClick={() => handleTabChange("applied")}
            onKeyDown={(event) => handleTabKeyDown(event, "applied", handleTabChange)}
          >
            Applied Jobs ({summaryLoading && data.applied === null ? "..." : appliedCount})
          </button>
          <button
            type="button"
            role="tab"
            id="saved-jobs-tab"
            aria-selected={activeTab === "saved"}
            aria-controls="saved-jobs-panel"
            tabIndex={activeTab === "saved" ? 0 : -1}
            className="inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 aria-selected:bg-background aria-selected:text-foreground aria-selected:shadow-sm"
            onClick={() => handleTabChange("saved")}
            onKeyDown={(event) => handleTabKeyDown(event, "saved", handleTabChange)}
          >
            Saved Jobs ({summaryLoading && data.saved === null ? "..." : savedCount})
          </button>
        </div>

        <div
          role="tabpanel"
          id="applied-jobs-panel"
          aria-labelledby="applied-jobs-tab"
          hidden={activeTab !== "applied"}
          className="mt-4"
        >
          <JobList
            collection="applied"
            pageData={activeTab === "applied" ? activeData : data.applied ?? emptyPage}
            loading={activeTab === "applied" && loading}
            error={activeTab === "applied" ? error : null}
            removingKey={removingKey}
            empty="No applications submitted yet."
            onRetry={refreshActivePage}
            onPageChange={(page) => setPages((current) => ({ ...current, applied: page }))}
            onView={(id) => navigate(`/jobs/${id}`)}
            onRequestRemoval={(job) => setPendingRemoval({ collection: "applied", job })}
          />
        </div>

        <div
          role="tabpanel"
          id="saved-jobs-panel"
          aria-labelledby="saved-jobs-tab"
          hidden={activeTab !== "saved"}
          className="mt-4"
        >
          <JobList
            collection="saved"
            pageData={activeTab === "saved" ? activeData : data.saved ?? emptyPage}
            loading={activeTab === "saved" && loading}
            error={activeTab === "saved" ? error : null}
            removingKey={removingKey}
            empty="No saved jobs yet."
            onRetry={refreshActivePage}
            onPageChange={(page) => setPages((current) => ({ ...current, saved: page }))}
            onView={(id) => navigate(`/jobs/${id}`)}
            onRequestRemoval={(job) => setPendingRemoval({ collection: "saved", job })}
          />
        </div>
      </section>

      {!loading && !error && totals.tracked === 0 ? (
        <div className="rounded-lg border bg-card p-8 text-center">
          <Inbox className="mx-auto h-8 w-8 text-muted-foreground" />
          <h2 className="font-display mt-3 font-semibold text-foreground">Start your job shortlist</h2>
          <p className="mx-auto mt-1 max-w-md text-sm text-muted-foreground">
            Save roles for later or submit an application to begin tracking progress here.
          </p>
          <Button size="sm" className="mt-4" onClick={() => navigate("/jobs")}>Browse jobs</Button>
        </div>
      ) : null}

      {!loading && !error ? (
        <section className="rounded-lg border bg-card p-5">
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
              <div key={label} className="flex gap-3 rounded-md bg-secondary/50 p-3">
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

function handleTabKeyDown(
  event: KeyboardEvent<HTMLButtonElement>,
  currentTab: JobCollection,
  onChange: (tab: JobCollection) => void,
) {
  if (event.key !== "ArrowLeft" && event.key !== "ArrowRight") return;
  event.preventDefault();
  onChange(currentTab === "applied" ? "saved" : "applied");
}

function JobList({
  collection,
  pageData,
  loading,
  error,
  empty,
  removingKey,
  onRetry,
  onPageChange,
  onView,
  onRequestRemoval,
}: {
  collection: JobCollection;
  pageData: PageResponse<SavedJob>;
  loading: boolean;
  error: string | null;
  empty: string;
  removingKey: string | null;
  onRetry: () => void;
  onPageChange: (page: number) => void;
  onView: (id: string) => void;
  onRequestRemoval: (job: SavedJob) => void;
}) {
  if (loading) {
    return (
      <div className="flex min-h-36 items-center justify-center rounded-md border bg-background text-muted-foreground">
        <Loader2 className="h-5 w-5 animate-spin" aria-label="Loading jobs" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-md border bg-background p-8 text-center">
        <AlertCircle className="mx-auto h-8 w-8 text-destructive" />
        <p className="mt-2 text-sm text-foreground">{error}</p>
        <Button type="button" size="sm" variant="outline" className="mt-4" onClick={onRetry}>
          Retry
        </Button>
      </div>
    );
  }

  if (pageData.content.length === 0) {
    return (
      <div className="flex min-h-36 flex-col items-center justify-center gap-2 rounded-md border bg-background p-6 text-center text-muted-foreground">
        <Inbox className="h-7 w-7" />
        <p className="text-sm">{empty}</p>
      </div>
    );
  }

  return (
    <div className="space-y-3">
      {pageData.content.map((job, index) => (
        <JobCard
          key={job.applicantJobId ?? getJobId(job) ?? index}
          job={job}
          collection={collection}
          index={index}
          removingKey={removingKey}
          onView={onView}
          onRequestRemoval={onRequestRemoval}
        />
      ))}
      <JobPagination pageData={pageData} onPageChange={onPageChange} />
    </div>
  );
}

function JobCard({
  job,
  collection,
  index,
  removingKey,
  onView,
  onRequestRemoval,
}: {
  job: SavedJob;
  collection: JobCollection;
  index: number;
  removingKey: string | null;
  onView: (id: string) => void;
  onRequestRemoval: (job: SavedJob) => void;
}) {
  const id = getJobId(job);
  const relationId = job.applicantJobId === undefined || job.applicantJobId === null ? "" : String(job.applicantJobId);
  const isRemoving = removingKey === `${collection}:${relationId}`;
  const dateLabel = collection === "applied" ? job.appliedAt : job.savedAt;

  return (
    <motion.article
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.03 }}
      className="rounded-md border bg-background p-4"
    >
      <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
        <div className="min-w-0 space-y-2">
          <div className="flex flex-wrap items-center gap-2">
            <h3 className="font-display text-base font-semibold text-foreground break-words">{job.jobTitle ?? "Untitled"}</h3>
            {collection === "applied" ? (
              <Badge variant="outline" className="rounded-md">
                {job.status ?? "Applied"}
              </Badge>
            ) : null}
          </div>
          <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
            {job.companyName ? <span className="inline-flex items-center gap-1"><Briefcase className="h-3.5 w-3.5" /> {job.companyName}</span> : null}
            {job.location ? <span className="inline-flex items-center gap-1"><MapPin className="h-3.5 w-3.5" /> {job.location}</span> : null}
            {job.jobType ? <span className="inline-flex items-center gap-1"><ListChecks className="h-3.5 w-3.5" /> {job.jobType}</span> : null}
            {dateLabel ? <span className="inline-flex items-center gap-1"><Calendar className="h-3.5 w-3.5" /> {dateLabel}</span> : null}
          </div>
        </div>
        <div className="flex shrink-0 flex-wrap gap-2">
          <Button size="sm" variant="outline" onClick={() => onView(id)} disabled={!id} aria-label={`View ${job.jobTitle ?? "job"}`}>
            View
          </Button>
          <Button
            size="sm"
            variant={collection === "applied" ? "destructive" : "outline"}
            disabled={!relationId || isRemoving}
            className={collection === "saved" ? "gap-1.5 text-destructive hover:bg-destructive/10 hover:text-destructive" : "gap-1.5"}
            onClick={() => onRequestRemoval(job)}
            aria-label={collection === "applied" ? `Withdraw ${job.jobTitle ?? "application"}` : `Remove ${job.jobTitle ?? "saved job"}`}
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
      </div>
    </motion.article>
  );
}

function JobPagination({
  pageData,
  onPageChange,
}: {
  pageData: PageResponse<SavedJob>;
  onPageChange: (page: number) => void;
}) {
  if (pageData.totalPages <= 1) return null;
  const currentPage = pageData.page + 1;

  return (
    <nav className="flex flex-col items-center justify-between gap-3 pt-2 sm:flex-row" aria-label="Job list pagination">
      <p className="text-xs text-muted-foreground">
        Page {currentPage} of {pageData.totalPages}
      </p>
      <div className="flex gap-2">
        <Button
          type="button"
          variant="outline"
          size="sm"
          disabled={pageData.first}
          onClick={() => onPageChange(Math.max(pageData.page - 1, 0))}
        >
          Previous
        </Button>
        <Button
          type="button"
          variant="outline"
          size="sm"
          disabled={pageData.last}
          onClick={() => onPageChange(pageData.page + 1)}
        >
          Next
        </Button>
      </div>
    </nav>
  );
}
