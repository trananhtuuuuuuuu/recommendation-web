import { useEffect, useMemo, useState } from "react";
import { User, Shield, MapPin, Eye, Mail, Loader2, AlertCircle, Inbox, Search } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useNavigate } from "react-router-dom";
import { ApiError } from "@/lib/api";
import { fetchApplicants, type Applicant } from "@/lib/jobsApi";

const statusColors: Record<string, string> = {
  OpenToWork: "bg-success/10 text-success",
  Normal: "bg-muted text-muted-foreground",
  Archived: "bg-muted text-muted-foreground",
};

export default function Applicants() {
  const navigate = useNavigate();
  const [applicants, setApplicants] = useState<Applicant[]>([]);
  const [query, setQuery] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    fetchApplicants()
      .then((data) => { if (active) setApplicants(Array.isArray(data) ? data : []); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load applicants"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, []);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return applicants;
    return applicants.filter((applicant) =>
      [applicant.fullName, applicant.userName, applicant.email, applicant.address, applicant.status]
        .filter(Boolean)
        .some((value) => String(value).toLowerCase().includes(q))
    );
  }, [applicants, query]);

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Applicants</h1>
          <p className="text-sm text-muted-foreground mt-1">Candidate profiles from the backend</p>
        </div>
        <div className="relative w-full sm:w-72">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search applicants..." className="pl-9" />
        </div>
      </div>

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
          <p className="text-sm text-muted-foreground">No applicants found.</p>
        </div>
      )}

      <div className="space-y-3">
        {filtered.map((applicant, i) => (
          <motion.div
            key={applicant.id ?? applicant.userName ?? i}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.04 }}
            className="glass-card rounded-xl p-5"
          >
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div className="flex items-center gap-4 min-w-0">
                <div className="w-11 h-11 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                  <User className="w-5 h-5 text-primary" />
                </div>
                <div className="min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <h3 className="font-display font-semibold text-foreground text-sm">{applicant.fullName ?? applicant.userName ?? "Applicant"}</h3>
                    {applicant.status && <Badge className={`text-[10px] ${statusColors[applicant.status] ?? "bg-muted text-muted-foreground"}`}>{applicant.status}</Badge>}
                    {applicant.cvId && <Badge className="text-[10px] bg-primary/10 text-primary"><Shield className="w-2.5 h-2.5 mr-0.5" /> CV</Badge>}
                  </div>
                  <div className="flex flex-wrap items-center gap-3 mt-1 text-xs text-muted-foreground">
                    {applicant.email && <span className="flex items-center gap-1"><Mail className="w-3 h-3" /> {applicant.email}</span>}
                    {applicant.address && <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {applicant.address}</span>}
                  </div>
                </div>
              </div>
              <Button variant="outline" size="sm" className="gap-1 text-xs" onClick={() => navigate(`/applicants/${applicant.id}`)}>
                <Eye className="w-3 h-3" /> Profile
              </Button>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
