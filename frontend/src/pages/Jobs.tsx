import { useEffect, useMemo, useState } from "react";
import {
  Briefcase, MapPin, Clock, Filter, ChevronDown, Sparkles, X, Loader2, ChevronUp,
  Bookmark, Eye, AlertCircle, Inbox
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useNavigate } from "react-router-dom";
import { fetchJobs, getJobId, getJobTitle, saveJob, type Job } from "@/lib/jobsApi";
import { ApiError } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";

interface Analysis { matchPercent: number; pros: string[]; cons: string[]; suggestions: string[] }
function mockAnalysis(seed: string): Analysis {
  const n = [...seed].reduce((a, c) => a + c.charCodeAt(0), 0);
  const pct = 40 + (n % 55);
  return {
    matchPercent: pct,
    pros: ["Strong overall fit with your skill set", "Compensation aligns with market"],
    cons: ["Some required tools not on your CV", "Limited domain experience"],
    suggestions: ["Tailor your CV summary to this role", "Add 1-2 highlighted projects matching keywords"],
  };
}

export default function Jobs() {
  const navigate = useNavigate();
  const { user, role, isAuthenticated } = useAuth();

  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [locationFilter, setLocationFilter] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [industryFilter, setIndustryFilter] = useState("");

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
    fetchJobs()
      .then((data) => { if (active) setJobs(Array.isArray(data) ? data : []); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load jobs"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, []);

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

  const handleCompareAll = () => {
    setComparingAll(true);
    setSingleResults({});
    setExpandedSuggestion(null);
    setTimeout(() => {
      const results: Record<string, Analysis> = {};
      filtered.forEach((j) => { results[getJobId(j)] = mockAnalysis(getJobId(j) + getJobTitle(j)); });
      setAllResults(results);
      setCompareAll(true);
      setComparingAll(false);
    }, 800);
  };

  const handleSingleSuggestion = (job: Job) => {
    const id = getJobId(job);
    if (singleResults[id]) { setExpandedSuggestion(expandedSuggestion === id ? null : id); return; }
    setSingleLoading(id);
    setTimeout(() => {
      setSingleResults((prev) => ({ ...prev, [id]: mockAnalysis(id + getJobTitle(job)) }));
      setExpandedSuggestion(id);
      setSingleLoading(null);
    }, 600);
  };

  const getResult = (id: string) => compareAll ? allResults[id] : singleResults[id];
  const clearAll = () => { setCompareAll(false); setAllResults({}); setSingleResults({}); setExpandedSuggestion(null); };

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="rounded-lg border bg-card p-5 flex flex-col xl:flex-row xl:items-center justify-between gap-4">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Job Listings</h1>
          <p className="text-sm text-muted-foreground mt-1">Browse open opportunities</p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search title, company..."
            className="px-3 py-2 text-sm bg-secondary rounded-lg outline-none focus:ring-2 focus:ring-primary/30 w-56"
          />
          <select value={locationFilter} onChange={(e) => setLocationFilter(e.target.value)}
            className="px-3 py-2 text-sm bg-secondary rounded-lg outline-none focus:ring-2 focus:ring-primary/30">
            <option value="">All locations</option>
            {filterOptions.locations.map((value) => <option key={value} value={value}>{value}</option>)}
          </select>
          <select value={typeFilter} onChange={(e) => setTypeFilter(e.target.value)}
            className="px-3 py-2 text-sm bg-secondary rounded-lg outline-none focus:ring-2 focus:ring-primary/30">
            <option value="">All types</option>
            {filterOptions.types.map((value) => <option key={value} value={value}>{value}</option>)}
          </select>
          <select value={industryFilter} onChange={(e) => setIndustryFilter(e.target.value)}
            className="px-3 py-2 text-sm bg-secondary rounded-lg outline-none focus:ring-2 focus:ring-primary/30">
            <option value="">All industries</option>
            {filterOptions.industries.map((value) => <option key={value} value={value}>{value}</option>)}
          </select>
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
          <Button variant="outline" className="gap-2" onClick={() => { setQuery(""); setLocationFilter(""); setTypeFilter(""); setIndustryFilter(""); }}>
            <Filter className="w-4 h-4" /> Filters <ChevronDown className="w-3 h-3" />
          </Button>
        </div>
      </div>

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
                      <Badge className={`text-[10px] font-bold ${
                        result.matchPercent >= 80 ? "bg-success/15 text-success" :
                        result.matchPercent >= 60 ? "bg-warning/15 text-warning" :
                        "bg-destructive/15 text-destructive"
                      }`}>
                        <Sparkles className="w-3 h-3 mr-1" /> {result.matchPercent}% Match
                      </Badge>
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
                    <div className="mt-4 pt-4 border-t border-border grid sm:grid-cols-3 gap-4">
                      <div className="space-y-2">
                        <h4 className="text-xs font-semibold text-success">Pros</h4>
                        <ul className="space-y-1">{result.pros.map((p, i) => <li key={i} className="text-xs text-muted-foreground">• {p}</li>)}</ul>
                      </div>
                      <div className="space-y-2">
                        <h4 className="text-xs font-semibold text-destructive">Cons</h4>
                        <ul className="space-y-1">{result.cons.map((c, i) => <li key={i} className="text-xs text-muted-foreground">• {c}</li>)}</ul>
                      </div>
                      <div className="space-y-2">
                        <h4 className="text-xs font-semibold text-primary">Suggestions</h4>
                        <ul className="space-y-1">{result.suggestions.map((s, i) => <li key={i} className="text-xs text-muted-foreground">• {s}</li>)}</ul>
                      </div>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
