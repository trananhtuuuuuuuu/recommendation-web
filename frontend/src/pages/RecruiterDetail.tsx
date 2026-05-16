import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Building2, Mail, Phone, MapPin, ArrowLeft, Briefcase, Loader2, AlertCircle, Globe } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ApiError } from "@/lib/api";
import { fetchRecruiter, fetchRecruiterJobs, type Job, type Recruiter } from "@/lib/jobsApi";

export default function RecruiterDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [recruiter, setRecruiter] = useState<Recruiter | null>(null);
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    let active = true;
    setLoading(true);
    Promise.all([fetchRecruiter(id), fetchRecruiterJobs(id).catch(() => [])])
      .then(([recruiterData, jobsData]) => {
        if (!active) return;
        setRecruiter(recruiterData);
        setJobs(Array.isArray(jobsData) ? jobsData : []);
      })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load recruiter"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [id]);

  if (loading) {
    return <div className="text-center pt-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>;
  }

  if (error || !recruiter) {
    return (
      <div className="max-w-lg mx-auto pt-16 text-center space-y-3">
        <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
        <p className="text-sm text-foreground">{error ?? "Recruiter not found"}</p>
        <Button variant="outline" onClick={() => navigate(-1)}>Back</Button>
      </div>
    );
  }

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6">
        <div className="flex items-center gap-5">
          <div className="w-16 h-16 rounded-full bg-primary/15 flex items-center justify-center">
            <Building2 className="w-7 h-7 text-primary" />
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1 flex-wrap">
              <h2 className="font-display text-xl font-bold text-foreground">{recruiter.companyName ?? recruiter.userName ?? "Recruiter"}</h2>
              <Badge className="bg-primary/10 text-primary text-[10px]">ID: {recruiter.id}</Badge>
            </div>
            {recruiter.industry && <p className="text-sm text-muted-foreground mb-2">{recruiter.industry}</p>}
            <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
              {recruiter.email && <span className="flex items-center gap-1"><Mail className="w-3.5 h-3.5" /> {recruiter.email}</span>}
              {(recruiter.contactPhone || recruiter.phone) && <span className="flex items-center gap-1"><Phone className="w-3.5 h-3.5" /> {recruiter.contactPhone ?? recruiter.phone}</span>}
              {(recruiter.companyLocation || recruiter.address) && <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {recruiter.companyLocation ?? recruiter.address}</span>}
            </div>
          </div>
        </div>
      </motion.div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-2">About</h3>
        <p className="text-sm text-muted-foreground">{recruiter.companyDescription ?? "No company description yet."}</p>
        {recruiter.website && (
          <a href={recruiter.website} target="_blank" rel="noreferrer" className="inline-flex items-center gap-1 text-sm text-primary mt-3 hover:underline">
            <Globe className="w-3.5 h-3.5" /> {recruiter.website}
          </a>
        )}
      </div>

      <div className="glass-card rounded-xl p-6 flex items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <Briefcase className="w-5 h-5 text-primary" />
          <div>
            <p className="font-display font-semibold text-foreground">{jobs.length} Jobs Posted</p>
            <p className="text-xs text-muted-foreground">Loaded from recruiter jobs API</p>
          </div>
        </div>
        <Button size="sm" variant="outline" onClick={() => navigate("/recruiters/jobs")}>View Jobs</Button>
      </div>
    </div>
  );
}
