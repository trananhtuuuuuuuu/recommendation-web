import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { User, Mail, Phone, MapPin, Shield, ArrowLeft, Briefcase, Loader2, AlertCircle, Download, GraduationCap, Award } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ApiError, resolveApiAssetUrl } from "@/lib/api";
import { fetchApplicant, type Applicant } from "@/lib/jobsApi";

export default function ApplicantDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [applicant, setApplicant] = useState<Applicant | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    let active = true;
    setLoading(true);
    fetchApplicant(id)
      .then((data) => { if (active) setApplicant(data); })
      .catch((e) => { if (active) setError(e instanceof ApiError ? e.message : "Failed to load applicant"); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [id]);

  if (loading) {
    return <div className="text-center pt-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>;
  }
  if (error || !applicant) {
    return (
      <div className="max-w-lg mx-auto pt-16 text-center space-y-3">
        <AlertCircle className="w-8 h-8 text-destructive mx-auto" />
        <p className="text-sm text-foreground">{error ?? "Applicant not found"}</p>
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
            <User className="w-7 h-7 text-primary" />
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1 flex-wrap">
              <h2 className="font-display text-xl font-bold text-foreground">{applicant.fullName ?? applicant.userName ?? "Applicant"}</h2>
              <Badge className="bg-primary/10 text-primary text-[10px]"><Shield className="w-3 h-3 mr-1" />Shared profile</Badge>
              {applicant.status && <Badge className={`${applicant.status === "OpenToWork" ? "bg-success/10 text-success" : "bg-muted text-muted-foreground"} text-[10px]`}>{applicant.status}</Badge>}
            </div>
            <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
              {applicant.email && <span className="flex items-center gap-1"><Mail className="w-3.5 h-3.5" /> {applicant.email}</span>}
              {applicant.phone && <span className="flex items-center gap-1"><Phone className="w-3.5 h-3.5" /> {applicant.phone}</span>}
              {applicant.address && <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {applicant.address}</span>}
              {!applicant.email && !applicant.phone && !applicant.address ? (
                <span className="text-xs">Contact and location fields are not shared.</span>
              ) : null}
            </div>
            {applicant.privacyNotice && (
              <p className="mt-2 text-xs text-muted-foreground">{applicant.privacyNotice}</p>
            )}
          </div>
        </div>
      </motion.div>

      <div className="grid sm:grid-cols-2 gap-4">
        <div className="glass-card rounded-xl p-6">
          <h3 className="font-display font-semibold text-foreground mb-3">Profile</h3>
          <div className="space-y-2 text-sm text-muted-foreground">
            {applicant.userName ? <p>Username: <span className="text-foreground">{applicant.userName}</span></p> : null}
            {applicant.gender ? <p>Gender: <span className="text-foreground">{applicant.gender}</span></p> : null}
            {applicant.status ? <p>Status: <span className="text-foreground">{applicant.status}</span></p> : null}
            {!applicant.userName && !applicant.gender && !applicant.status ? <p>No additional profile fields shared.</p> : null}
          </div>
        </div>

        <div className="glass-card rounded-xl p-6">
          <h3 className="font-display font-semibold text-foreground mb-3 flex items-center gap-2">
            <Briefcase className="w-4 h-4 text-primary" /> CV
          </h3>
          {applicant.cv ? (
            <div className="space-y-2 text-sm text-muted-foreground">
              {applicant.cv.objective ? <p>Objective: <span className="text-foreground">{applicant.cv.objective}</span></p> : null}
              {formatList(applicant.cv.skills) ? <p>Skills: <span className="text-foreground">{formatList(applicant.cv.skills)}</span></p> : null}
              {applicant.cv.experience ? <p>Experience: <span className="text-foreground whitespace-pre-line">{formatExperience(applicant.cv.experience)}</span></p> : null}
              {applicant.cv.education ? (
                <p className="flex items-start gap-1"><GraduationCap className="mt-0.5 h-4 w-4 shrink-0 text-primary" /> Education: <span className="text-foreground">{formatRecord(applicant.cv.education)}</span></p>
              ) : null}
              {applicant.cv.certifications ? (
                <p className="flex items-start gap-1"><Award className="mt-0.5 h-4 w-4 shrink-0 text-primary" /> Certifications: <span className="text-foreground">{formatRecord(applicant.cv.certifications)}</span></p>
              ) : null}
              {applicant.cv.cvFileUrl ? (
                <Button asChild size="sm" variant="outline" className="mt-3 gap-2">
                  <a href={resolveApiAssetUrl(applicant.cv.cvFileUrl)} target="_blank" rel="noreferrer" download>
                    <Download className="h-4 w-4" /> Download CV file
                  </a>
                </Button>
              ) : null}
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">No CV uploaded yet.</p>
          )}
        </div>
      </div>
    </div>
  );
}

function formatExperience(value?: string | Record<string, unknown> | null) {
  if (!value) return "N/A";
  if (typeof value === "object") {
    const contribution = typeof value.contribution === "string" ? value.contribution : "";
    if (contribution) {
      const parsed = formatExperience(contribution);
      if (parsed !== "N/A") return parsed;
    }
    return [value.jobTitle, value.companyName, value.startDate, value.endDate]
      .filter(Boolean)
      .join(" - ") || "N/A";
  }
  try {
    const parsed = JSON.parse(value);
    if (Array.isArray(parsed)) {
      const formatted = parsed
        .map((item) => [item.position ?? item.jobTitle, item.companyName, item.time].filter(Boolean).join(" - "))
        .filter(Boolean)
        .join("\n");
      return formatted || "N/A";
    }
  } catch {
    return value;
  }
  return value;
}

function formatList(value?: string | string[] | null) {
  return Array.isArray(value) ? value.filter(Boolean).join(", ") : value;
}

function formatRecord(value?: string | Record<string, unknown> | null) {
  if (!value) return "";
  if (typeof value === "string") return value;
  return Object.values(value).filter((item) => item !== null && item !== undefined && item !== "").join(" · ");
}
