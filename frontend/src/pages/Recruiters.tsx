import { useEffect, useMemo, useState } from "react";
import {
  AlertCircle,
  Briefcase,
  Building2,
  ExternalLink,
  Globe2,
  Inbox,
  Layers3,
  Loader2,
  MapPin,
  MapPinned,
  Search,
  Shield,
} from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useNavigate } from "react-router-dom";
import { ApiError } from "@/lib/api";
import { fetchRecruiters, type Recruiter } from "@/lib/jobsApi";
import MetricCard from "@/components/MetricCard";

export default function Recruiters() {
  const navigate = useNavigate();
  const [recruiters, setRecruiters] = useState<Recruiter[]>([]);
  const [query, setQuery] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    fetchRecruiters()
      .then((data) => { if (active) setRecruiters(Array.isArray(data) ? data : []); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load recruiters"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, []);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return recruiters;
    return recruiters.filter((recruiter) =>
      [recruiter.companyName, recruiter.userName, recruiter.email, recruiter.industry, recruiter.companyLocation]
        .filter(Boolean)
        .some((value) => String(value).toLowerCase().includes(q))
    );
  }, [recruiters, query]);

  const summary = useMemo(() => ({
    industries: new Set(recruiters.map((recruiter) => recruiter.industry).filter(Boolean)).size,
    withWebsite: recruiters.filter((recruiter) => recruiter.website).length,
    withLocation: recruiters.filter((recruiter) => recruiter.companyLocation || recruiter.address).length,
  }), [recruiters]);

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Recruiters</h1>
          <p className="text-sm text-muted-foreground mt-1">Companies and recruiter accounts from the backend</p>
        </div>
        <div className="relative w-full sm:w-72">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search recruiters..." className="pl-9" />
        </div>
      </div>

      {!loading && !error ? (
        <div className="grid grid-cols-2 gap-3 lg:grid-cols-4">
          <MetricCard icon={Building2} label="Recruiter accounts" value={recruiters.length} hint="Companies in the directory" />
          <MetricCard icon={Layers3} label="Industries" value={summary.industries} hint="Distinct hiring sectors" />
          <MetricCard icon={Globe2} label="Company websites" value={summary.withWebsite} hint="Profiles with external sites" />
          <MetricCard icon={MapPinned} label="Locations listed" value={summary.withLocation} hint="Profiles with an address" />
        </div>
      ) : null}

      {loading && <div className="text-center py-10"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>}

      {error && !loading && (
        <div className="glass-card rounded-xl p-8 text-center space-y-2">
          <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
          <p className="text-sm">{error}</p>
        </div>
      )}

      {!loading && !error && filtered.length === 0 && (
        <div className="glass-card rounded-xl p-10 text-center space-y-2">
          <Inbox className="w-8 h-8 text-muted-foreground mx-auto" />
          <p className="text-sm text-muted-foreground">No recruiters found.</p>
        </div>
      )}

      <div className="grid md:grid-cols-2 gap-4">
        {filtered.map((recruiter, i) => (
          <motion.div
            key={recruiter.id ?? recruiter.userName ?? i}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.04 }}
            className="glass-card rounded-xl p-5 hover:shield-glow transition-shadow group"
          >
            <div className="flex items-start justify-between mb-3 gap-3">
              <div className="flex items-center gap-3 min-w-0">
                <div className="w-11 h-11 rounded-lg bg-primary/10 flex items-center justify-center shrink-0">
                  <Building2 className="w-5 h-5 text-primary" />
                </div>
                <div className="min-w-0">
                  <div className="flex items-center gap-2">
                    <h3 className="font-display font-semibold text-foreground truncate">{recruiter.companyName ?? recruiter.userName ?? "Recruiter"}</h3>
                    <Shield className="w-3.5 h-3.5 text-primary shrink-0" />
                  </div>
                  <p className="text-xs text-muted-foreground">{recruiter.industry ?? "No industry provided"}</p>
                </div>
              </div>
              {recruiter.companySize && <Badge className="bg-primary/10 text-primary text-[10px]">{recruiter.companySize}</Badge>}
            </div>
            <p className="text-sm text-muted-foreground mb-3 line-clamp-2">
              {recruiter.companyDescription ?? "No company description yet."}
            </p>
            <div className="flex items-center justify-between gap-3">
              <div className="flex flex-wrap gap-4 text-xs text-muted-foreground">
                {(recruiter.companyLocation || recruiter.address) && (
                  <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {recruiter.companyLocation ?? recruiter.address}</span>
                )}
                <span className="flex items-center gap-1"><Briefcase className="w-3 h-3" /> Jobs</span>
              </div>
              <Button variant="outline" size="sm" className="gap-1 text-xs" onClick={() => navigate(`/recruiters/${recruiter.id}`)}>
                View <ExternalLink className="w-3 h-3" />
              </Button>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
