import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { motion } from "framer-motion";
import { Save, ArrowLeft, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { createRecruiterJob, fetchJob, updateRecruiterJob, type Job } from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";
import { toast } from "sonner";

const empty: Job = {
  jobTitle: "", aboutCompany: "", jobDescription: "", requirements: "", benefits: "",
  location: "", salaryRange: "", jobType: "Full-time", experienceLevel: "", industry: "",
  postedDate: "", applicationDeadline: "", startDate: "", endDate: "",
};

export default function PostEditJob() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const isEdit = Boolean(id);

  const [form, setForm] = useState<Job>(empty);
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!isEdit || !id) return;
    fetchJob(id)
      .then((j) => setForm({ ...empty, ...j }))
      .catch(() => toast.error("Failed to load job"))
      .finally(() => setLoading(false));
  }, [id, isEdit]);

  const update = (k: keyof Job, v: string) => setForm({ ...form, [k]: v });

  const submit = async () => {
    if (!user?.id) { toast.error("Missing recruiter ID"); return; }
    setSaving(true); setErrors({});
    try {
      if (isEdit && id) await updateRecruiterJob(user.id, id, form);
      else await createRecruiterJob(user.id, form);
      toast.success(isEdit ? "Job updated" : "Job posted");
      navigate("/recruiters/jobs");
    } catch (e) {
      if (e instanceof ApiError) {
        if (e.errors && !Array.isArray(e.errors)) setErrors(e.errors as Record<string, string>);
        toast.error(e.message);
      } else toast.error("Save failed");
    } finally { setSaving(false); }
  };

  if (loading) {
    return <div className="text-center pt-8"><Loader2 className="w-5 h-5 animate-spin mx-auto text-muted-foreground" /></div>;
  }

  const field = (k: keyof Job, label: string, opts: { placeholder?: string; type?: string; rows?: number; textarea?: boolean } = {}) => (
    <div className="space-y-1.5">
      <Label>{label}</Label>
      {opts.textarea ? (
        <Textarea rows={opts.rows ?? 3} value={String(form[k] ?? "")} onChange={(e) => update(k, e.target.value)} placeholder={opts.placeholder} />
      ) : (
        <Input type={opts.type ?? "text"} value={String(form[k] ?? "")} onChange={(e) => update(k, e.target.value)} placeholder={opts.placeholder} />
      )}
      {errors[k as string] && <p className="text-xs text-destructive">{errors[k as string]}</p>}
    </div>
  );

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6 space-y-5">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">{isEdit ? "Edit Job" : "Post New Job"}</h1>
          <p className="text-sm text-muted-foreground mt-1">{isEdit ? "Update job details" : "Create a new job posting"}</p>
        </div>

        <div className="grid sm:grid-cols-2 gap-4">
          {field("jobTitle", "Job Title", { placeholder: "Senior Developer" })}
          {field("location", "Location", { placeholder: "Remote" })}
          {field("jobType", "Job Type")}
          {field("experienceLevel", "Experience Level", { placeholder: "Mid / Senior" })}
          {field("industry", "Industry")}
          {field("salaryRange", "Salary Range", { placeholder: "$100K - $140K" })}
          {field("postedDate", "Posted Date", { type: "date" })}
          {field("applicationDeadline", "Application Deadline", { type: "date" })}
          {field("startDate", "Start Date", { type: "date" })}
          {field("endDate", "End Date", { type: "date" })}
        </div>

        {field("aboutCompany", "About Company", { textarea: true })}
        {field("jobDescription", "Description", { textarea: true })}
        {field("requirements", "Requirements", { textarea: true })}
        {field("benefits", "Benefits", { textarea: true })}

        <div className="flex gap-3">
          <Button onClick={submit} disabled={saving} className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2">
            {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
            {isEdit ? "Save Changes" : "Publish Job"}
          </Button>
          <Button variant="outline" onClick={() => navigate(-1)}>Cancel</Button>
        </div>
      </motion.div>
    </div>
  );
}
