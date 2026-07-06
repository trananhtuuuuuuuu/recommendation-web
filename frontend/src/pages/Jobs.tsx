import { useEffect, useMemo, useState } from "react";
import {
  Briefcase, MapPin, Clock, Filter, ChevronDown, Sparkles, X, Loader2, ChevronUp,
  Bookmark, Eye, AlertCircle, Inbox
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useNavigate, useSearchParams } from "react-router-dom";
import { AI_MATCH_OPTIONS, fetchJobsPage, getJobId, getJobTitle, saveJob, matchCvToJob, type Job, type CvJobMatch, type PageResponse } from "@/lib/jobsApi";
import { ApiError } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";
import { Label } from "@/components/ui/label";

interface Analysis {
  matchPercent: number;
  passedFilter: boolean;
  reason: string;
  suggestions: string[];
  hardFilterReasons: string[];
}

const JOB_PAGE_SIZE = 10;

const emptyJobsPage: PageResponse<Job> = {
  content: [],
  page: 0,
  size: JOB_PAGE_SIZE,
  totalElements: 0,
  totalPages: 0,
  first: true,
  last: true,
};

function toAnalysis(match: CvJobMatch): Analysis {
  return {
    matchPercent: match.matchPercent ?? Math.round((match.matchScore ?? 0) * 100),
    passedFilter: match.passedFilter ?? true,
    reason: match.reason ?? "",
    suggestions: match.suggestions ?? [],
    hardFilterReasons: match.hardFilterReasons ?? [],
  };
}

export default function Jobs() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { user, role, isAuthenticated } = useAuth();

  const [jobs, setJobs] = useState<Job[]>([]);
  const [jobsPage, setJobsPage] = useState<PageResponse<Job>>(emptyJobsPage);
  const [currentPage, setCurrentPage] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [locationFilter, setLocationFilter] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [industryFilter, setIndustryFilter] = useState("");
  const [filtersOpen, setFiltersOpen] = useState(false);

  const [compareAll, setCompareAll] = useState(false);
  const [comparingAll, setComparingAll] = useState(false);
  const [allResults, setAllResults] = useState<Record<string, Analysis>>({});
  const [singleLoading, setSingleLoading] = useState<string | null>(null);
  const [singleResults, setSingleResults] = useState<Record<string, Analysis>>({});
  const [expandedSuggestion, setExpandedSuggestion] = useState<string | null>(null);
  const [savedJobs, setSavedJobs] = useState<Set<string>>(new Set());
  const [savingId, setSavingId] = useState<string | null>(null);
  const [appliedJobs, setAppliedJobs] = useState<Set<string>>(new Set());

  useEffect(() => {
    let active = true;
    setLoading(true);
    setError(null);
    fetchJobsPage(currentPage, JOB_PAGE_SIZE)
      .then((data) => {
        if (!active) return;
        setJobsPage(data);
        setJobs(data.content);
      })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load jobs"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [currentPage]);

  useEffect(() => {
    setQuery(searchParams.get("q") ?? "");
  }, [searchParams]);

  useEffect(() => {
    setCurrentPage(0);
  }, [query, locationFilter, typeFilter, industryFilter]);

  const filtered = useMemo(() => {
    const q = query.toLowerCase();
    return jobs.filter((j) =>
      (!q || [getJobTitle(j), j.companyName, j.location, j.industry, j.jobDescription, j.requirements]
        .filter(Boolean).some((v) => String(v).toLowerCase().includes(q))
      ) &&
      (!locationFilter || j.location === locationFilter) &&
      (!typeFilter || j.jobType === typeFilter) &&
      (!industryFilter || j.industry === industryFilter)
    );
  }, [jobs, query, locationFilter, typeFilter, industryFilter]);

  const filterOptions = useMemo(() => ({
    locations: Array.from(new Set(jobs.map((j) => j.location).filter(Boolean))) as string[],
    types: Array.from(new Set(jobs.map((j) => j.jobType).filter(Boolean))) as string[],
    industries: Array.from(new Set(jobs.map((j) => j.industry).filter(Boolean))) as string[],
  }), [jobs]);

  const activeFilterCount = [locationFilter, typeFilter, industryFilter].filter(Boolean).length;

  const clearFilters = () => {
    setLocationFilter("");
    setTypeFilter("");
    setIndustryFilter("");
  };

  const handleSave = async (job: Job) => {
    const id = getJobId(job);
    if (!isAuthenticated) { navigate("/auth"); return; }
    if (role !== "APPLICANT") { toast.error("Only applicants can save jobs."); return; }
    if (!user?.id) { toast.error("Missing applicant ID in session."); return; }
    setSavingId(id);
    try {
      await saveJob(user.id, id);
      setSavedJobs((prev) => new Set(prev).add(id));
      toast.success("Job saved.");
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Failed to save job");
    } finally {
      setSavingId(null);
    }
  };

  const handleCompareAll = async () => {
    if (!user?.id) { toast.error("Missing applicant ID in session."); return; }
    const applicantId = user.id;
    setComparingAll(true);
    setSingleResults({});
    setExpandedSuggestion(null);
    try {
      const entries = await Promise.all(
        filtered.map(async (j) => {
          const jobId = getJobId(j);
          try { return [jobId, toAnalysis(await matchCvToJob(applicantId, jobId))] as const; }
          catch { return [jobId, null] as const; }
        })
      );
      const results: Record<string, Analysis> = {};
      entries.forEach(([jobId, analysis]) => { if (analysis) results[jobId] = analysis; });
      setAllResults(results);
      setCompareAll(true);
      if (Object.keys(results).length === 0) {
        toast.error("Could not match these jobs. Make sure your CV is uploaded.");
      }
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Failed to compare jobs");
    } finally {
      setComparingAll(false);
    }
  };

  const handleSingleSuggestion = async (job: Job) => {
    const id = getJobId(job);
    if (singleResults[id]) { setExpandedSuggestion(expandedSuggestion === id ? null : id); return; }
    if (!user?.id) { toast.error("Missing applicant ID in session."); return; }
    setSingleLoading(id);
    try {
      // Single job -> richer Ollama (qwen2.5:3b) suggestions; "Compare All" stays fast (llm:false).
      const analysis = toAnalysis(await matchCvToJob(user.id, id, AI_MATCH_OPTIONS));
      setSingleResults((prev) => ({ ...prev, [id]: analysis }));
      setExpandedSuggestion(id);
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Failed to analyze match. Upload a CV first?");
    } finally {
      setSingleLoading(null);
    }
  };

  const getResult = (id: string) => compareAll ? allResults[id] : singleResults[id];
  const clearAll = () => { setCompareAll(false); setAllResults({}); setSingleResults({}); setExpandedSuggestion(null); };

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <Collapsible open={filtersOpen} onOpenChange={setFiltersOpen}>
        <div className="rounded-lg border bg-card p-5">
          <div className="flex flex-col justify-between gap-4 xl:flex-row xl:items-center">
            <div>
              <h1 className="font-display text-2xl font-bold text-foreground">Job Listings</h1>
              <p className="text-sm text-muted-foreground mt-1">
                {loading
                  ? "Loading open opportunities..."
                  : `${filtered.length} shown on page ${jobsPage.page + 1} of ${Math.max(jobsPage.totalPages, 1)} (${jobsPage.totalElements} total)`}
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <div className="relative w-full sm:w-auto">
                <input
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder="Search title, company..."
                  className="w-full rounded-lg bg-secondary px-3 py-2 pr-9 text-sm outline-none focus:ring-2 focus:ring-primary/30 sm:w-56"
                />
                {query ? (
                  <button
                    type="button"
                    aria-label="Clear job search"
                    onClick={() => setQuery("")}
                    className="absolute right-2.5 top-1/2 -translate-y-1/2 text-muted-foreground transition-colors hover:text-foreground"
                  >
                    <X className="h-3.5 w-3.5" />
                  </button>
                ) : null}
              </div>
              {(compareAll || Object.keys(singleResults).length > 0) && (
                <Button variant="ghost" size="sm" onClick={clearAll} className="gap-1 text-xs text-muted-foreground">
                  <X className="w-3 h-3" /> Clear AI
                </Button>
              )}
              {role === "APPLICANT" && (
                <Button onClick={handleCompareAll} disabled={comparingAll || loading || filtered.length === 0}
                  className="gap-2 bg-gradient-to-r from-primary to-accent text-primary-foreground hover:opacity-90">
                  {comparingAll ? <Loader2 className="w-4 h-4 animate-spin" /> : <Sparkles className="w-4 h-4" />}
                  {comparingAll ? "Analyzing..." : "AI Compare All"}
                </Button>
              )}
              <CollapsibleTrigger asChild>
                <Button
                  variant={activeFilterCount > 0 ? "secondary" : "outline"}
                  className="gap-2"
                  aria-expanded={filtersOpen}
                >
                  <Filter className="w-4 h-4" />
                  Filters
                  {activeFilterCount > 0 ? (
                    <Badge className="h-5 min-w-5 justify-center rounded-full px-1.5 text-[10px]">
                      {activeFilterCount}
                    </Badge>
                  ) : null}
                  {filtersOpen ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                </Button>
              </CollapsibleTrigger>
            </div>
          </div>

          <CollapsibleContent>
            <div className="mt-5 grid gap-4 border-t border-border pt-5 sm:grid-cols-2 xl:grid-cols-[1fr_1fr_1fr_auto] xl:items-end">
              <FilterSelect
                label="Location"
                value={locationFilter}
                onChange={setLocationFilter}
                options={filterOptions.locations}
                placeholder="All locations"
              />
              <FilterSelect
                label="Job type"
                value={typeFilter}
                onChange={setTypeFilter}
                options={filterOptions.types}
                placeholder="All job types"
              />
              <FilterSelect
                label="Industry"
                value={industryFilter}
                onChange={setIndustryFilter}
                options={filterOptions.industries}
                placeholder="All industries"
              />
              <Button
                variant="ghost"
                onClick={clearFilters}
                disabled={activeFilterCount === 0}
                className="justify-self-start gap-2 text-muted-foreground xl:justify-self-end"
              >
                <X className="h-4 w-4" /> Clear filters
              </Button>
            </div>
          </CollapsibleContent>
        </div>
      </Collapsible>

      {loading && (
        <div className="space-y-3">
          {[1, 2, 3].map((i) => (
            <div key={i} className="glass-card rounded-xl p-5 animate-pulse">
              <div className="h-4 bg-secondary rounded w-1/3 mb-3" />
              <div className="h-3 bg-secondary rounded w-2/3 mb-2" />
              <div className="h-3 bg-secondary rounded w-1/4" />
            </div>
          ))}
        </div>
      )}

      {error && !loading && (
        <div className="glass-card rounded-xl p-8 text-center space-y-2">
          <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
          <p className="text-sm text-foreground">{error}</p>
          <Button variant="outline" size="sm" onClick={() => location.reload()}>Retry</Button>
        </div>
      )}

      {!loading && !error && filtered.length === 0 && (
        <div className="glass-card rounded-xl p-10 text-center space-y-2">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <p className="text-sm text-muted-foreground">No jobs found.</p>
        </div>
      )}

      <div className="grid xl:grid-cols-2 gap-4">
        {filtered.map((job, i) => {
          const id = getJobId(job);
          const result = getResult(id);
          const isExpanded = expandedSuggestion === id;
          const isSaved = savedJobs.has(id);
          const isApplied = appliedJobs.has(id);

          return (
            <motion.div
              key={id || i}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.03 }}
              className="rounded-lg border bg-card p-5 hover:shield-glow transition-all group"
            >
              <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1 flex-wrap">
                    <h3 className="font-display font-semibold text-foreground group-hover:text-primary transition-colors">
                      {getJobTitle(job)}
                    </h3>
                    {result && (
                      result.passedFilter ? (
                        <Badge className={`text-[10px] font-bold ${
                          result.matchPercent >= 60 ? "bg-success/15 text-success" :
                          result.matchPercent >= 35 ? "bg-warning/15 text-warning" :
                          "bg-destructive/15 text-destructive"
                        }`}>
                          <Sparkles className="w-3 h-3 mr-1" /> {result.matchPercent}% Match
                        </Badge>
                      ) : (
                        <Badge className="text-[10px] font-bold bg-muted text-muted-foreground">
                          Does not meet requirements
                        </Badge>
                      )
                    )}
                  </div>
                  {job.jobDescription || job.description ? (
                    <p className="text-sm text-muted-foreground mb-3 line-clamp-2">
                      {job.jobDescription || job.description}
                    </p>
                  ) : null}
                  <div className="flex flex-wrap items-center gap-3 text-xs text-muted-foreground">
                    {job.companyName && <span className="flex items-center gap-1"><Briefcase className="w-3 h-3" /> {job.companyName}</span>}
                    {job.location && <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {job.location}</span>}
                    {job.postedDate && <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {job.postedDate}</span>}
                  </div>
                </div>
                <div className="text-right shrink-0 space-y-2">
                  {job.salaryRange && <p className="font-display font-semibold text-foreground text-sm">{job.salaryRange}</p>}
                  {job.jobType && <p className="text-xs text-muted-foreground">{job.jobType}</p>}
                  <div className="flex flex-col gap-1.5 mt-2">
                    <Button size="sm" variant="outline" className="gap-1 text-xs" onClick={() => navigate(`/jobs/${id}`)}>
                      <Eye className="w-3 h-3" /> View
                    </Button>
                    {role === "APPLICANT" && (
                      <>
                        <Button size="sm" disabled={isApplied}
                          className="gap-1 text-xs" onClick={() => navigate(`/jobs/${id}`)}>
                          <Briefcase className="w-3 h-3" />
                          {isApplied ? "Applied" : "Apply"}
                        </Button>
                        <Button size="sm" variant="outline" disabled={savingId === id}
                          className="gap-1 text-xs" onClick={() => handleSave(job)}>
                          {savingId === id ? <Loader2 className="w-3 h-3 animate-spin" /> :
                            <Bookmark className={`w-3 h-3 ${isSaved ? "fill-primary text-primary" : ""}`} />}
                          {isSaved ? "Saved" : "Save"}
                        </Button>
                        <Button size="sm" variant="outline"
                          className="gap-1 text-xs border-primary/30 text-primary hover:bg-primary/10"
                          disabled={singleLoading === id}
                          onClick={() => handleSingleSuggestion(job)}>
                          {singleLoading === id ? <Loader2 className="w-3 h-3 animate-spin" /> : <Sparkles className="w-3 h-3" />}
                          {result ? (isExpanded ? "Hide" : "Show") + " AI" : "AI Suggestion"}
                          {result && (isExpanded ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />)}
                        </Button>
                      </>
                    )}
                  </div>
                </div>
              </div>

              <AnimatePresence>
                {result && isExpanded && (
                  <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }} className="overflow-hidden">
                    <div className="mt-4 pt-4 border-t border-border space-y-3">
                      {result.reason && (
                        <div className="space-y-1">
                          <h4 className="text-xs font-semibold text-foreground">Reason</h4>
                          <p className="text-xs text-muted-foreground">{result.reason}</p>
                        </div>
                      )}
                      {!result.passedFilter && result.hardFilterReasons.length > 0 && (
                        <div className="space-y-1">
                          <h4 className="text-xs font-semibold text-destructive">Did not pass required filters</h4>
                          <ul className="space-y-1">{result.hardFilterReasons.map((c, idx) => <li key={idx} className="text-xs text-muted-foreground">• {c}</li>)}</ul>
                        </div>
                      )}
                      {result.suggestions.length > 0 && (
                        <div className="space-y-1">
                          <h4 className="text-xs font-semibold text-primary">Improvement suggestions</h4>
                          <ul className="space-y-1">{result.suggestions.map((s, idx) => <li key={idx} className="text-xs text-muted-foreground">• {s}</li>)}</ul>
                        </div>
                      )}
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          );
        })}
      </div>

      {!loading && !error && jobsPage.totalPages > 1 ? (
        <nav className="flex flex-col items-center justify-between gap-3 rounded-lg border bg-card p-4 sm:flex-row" aria-label="Job pagination">
          <p className="text-sm text-muted-foreground">
            Page {jobsPage.page + 1} of {jobsPage.totalPages}
          </p>
          <div className="flex gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              disabled={jobsPage.first || loading}
              onClick={() => setCurrentPage((page) => Math.max(page - 1, 0))}
            >
              Previous
            </Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              disabled={jobsPage.last || loading}
              onClick={() => setCurrentPage((page) => page + 1)}
            >
              Next
            </Button>
          </div>
        </nav>
      ) : null}
    </div>
  );
}

function FilterSelect({
  label,
  value,
  onChange,
  options,
  placeholder,
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  options: string[];
  placeholder: string;
}) {
  return (
    <div className="space-y-2">
      <Label className="text-xs">{label}</Label>
      <select
        value={value}
        onChange={(event) => onChange(event.target.value)}
        className="h-10 w-full rounded-md border border-input bg-background px-3 text-sm outline-none focus:ring-2 focus:ring-primary/30"
      >
        <option value="">{placeholder}</option>
        {options.map((option) => <option key={option} value={option}>{option}</option>)}
      </select>
    </div>
  );
}
