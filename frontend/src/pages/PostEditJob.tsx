import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { motion } from "framer-motion";
import { Save, ArrowLeft, Loader2, Plus, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { createRecruiterJob, fetchJob, updateRecruiterJob, type ApplicationField, type Job } from "@/lib/jobsApi";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";
import { toast } from "sonner";

const empty: Job = {
  jobTitle: "", aboutCompany: "", jobDescription: "", requirements: "", benefits: "",
  location: "", salaryRange: "", jobType: "Full-time", experienceLevel: "", industry: "",
  postedDate: "", applyingDeadline: "", startDate: "", endDate: "",
  customApplicationFields: "",
};

const defaultFields: ApplicationField[] = [
  { id: "years_in_role", label: "How many years have you worked in this role?", type: "text", required: true },
  { id: "english_level", label: "Current English level", type: "select", required: true, options: ["Beginner", "Intermediate", "Upper-intermediate", "Advanced", "Fluent"] },
  { id: "cover_letter", label: "Cover letter", type: "textarea", required: false },
  { id: "portfolio_url", label: "Portfolio URL", type: "url", required: false },
];

export default function PostEditJob() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const isEdit = Boolean(id);

  const [form, setForm] = useState<Job>(empty);
  const [useCustomForm, setUseCustomForm] = useState(false);
  const [applicationFields, setApplicationFields] = useState<ApplicationField[]>(defaultFields);
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!isEdit || !id) return;
    fetchJob(id)
      .then((j) => {
        setForm({ ...empty, ...j });
        const parsed = parseFields(j.customApplicationFields);
        if (parsed.length > 0) {
          setUseCustomForm(true);
          setApplicationFields(parsed);
        }
      })
      .catch(() => toast.error("Failed to load job"))
      .finally(() => setLoading(false));
  }, [id, isEdit]);

  const update = (k: keyof Job, v: string) => setForm({ ...form, [k]: v });

  const updateField = (index: number, patch: Partial<ApplicationField>) => {
    setApplicationFields((current) => current.map((field, i) => i === index ? { ...field, ...patch } : field));
  };

  const addField = () => {
    setApplicationFields((current) => [...current, {
      id: `question_${Date.now()}`,
      label: "",
      type: "text",
      required: false,
      options: [],
    }]);
  };

  const submit = async () => {
    if (!user?.id) { toast.error("Missing recruiter ID"); return; }
    setSaving(true); setErrors({});
    try {
      const payload = {
        ...form,
        customApplicationFields: useCustomForm ? JSON.stringify(applicationFields.filter((field) => field.label.trim())) : "",
      };
      if (isEdit && id) await updateRecruiterJob(user.id, id, payload);
      else await createRecruiterJob(user.id, payload);
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
    <div className="max-w-6xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6 space-y-5">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">{isEdit ? "Edit Job" : "Post New Job"}</h1>
          <p className="text-sm text-muted-foreground mt-1">{isEdit ? "Update job details" : "Create a new job posting"}</p>
        </div>

        <div className="grid lg:grid-cols-[1.2fr_0.8fr] gap-6 items-start">
          <div className="space-y-5">
            <div className="grid sm:grid-cols-2 gap-4">
              {field("jobTitle", "Job Title", { placeholder: "Senior Developer" })}
              {field("location", "Location", { placeholder: "Remote" })}
              {field("jobType", "Job Type")}
              {field("experienceLevel", "Experience Level", { placeholder: "Mid / Senior" })}
              {field("industry", "Industry")}
              {field("salaryRange", "Salary Range", { placeholder: "$100K - $140K" })}
              {field("postedDate", "Posted Date", { type: "date" })}
              {field("applyingDeadline", "Application Deadline", { type: "date" })}
              {field("startDate", "Start Date", { type: "date" })}
              {field("endDate", "End Date", { type: "date" })}
            </div>

            {field("aboutCompany", "About Company", { textarea: true })}
            {field("jobDescription", "Description", { textarea: true, rows: 4 })}
            {field("requirements", "Requirements", { textarea: true, rows: 4 })}
            {field("benefits", "Benefits", { textarea: true })}
          </div>

          <div className="rounded-lg border bg-card p-5 space-y-4">
            <div className="flex items-start justify-between gap-3">
              <div>
                <h2 className="font-display font-semibold text-foreground">Applicant Form</h2>
                <p className="text-xs text-muted-foreground mt-1">Add questions applicants must answer when applying.</p>
              </div>
              <label className="flex items-center gap-2 text-xs text-muted-foreground">
                <input type="checkbox" checked={useCustomForm} onChange={(e) => setUseCustomForm(e.target.checked)} />
                Enable
              </label>
            </div>

            {useCustomForm && (
              <div className="space-y-4">
                {applicationFields.map((customField, index) => (
                  <div key={customField.id} className="rounded-lg border bg-secondary/30 p-3 space-y-3">
                    <div className="flex gap-2">
                      <Input value={customField.label} placeholder="Question label" onChange={(e) => updateField(index, { label: e.target.value })} />
                      <Button variant="outline" size="icon" onClick={() => setApplicationFields((current) => current.filter((_, i) => i !== index))}>
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <select value={customField.type} onChange={(e) => updateField(index, { type: e.target.value as ApplicationField["type"] })}
                        className="px-3 py-2 text-sm bg-background rounded-md border border-input">
                        <option value="text">Text</option>
                        <option value="textarea">Long text</option>
                        <option value="select">Select list</option>
                        <option value="url">URL</option>
                      </select>
                      <label className="flex items-center gap-2 text-xs text-muted-foreground px-2">
                        <input type="checkbox" checked={Boolean(customField.required)} onChange={(e) => updateField(index, { required: e.target.checked })} />
                        Required
                      </label>
                    </div>
                    {customField.type === "select" && (
                      <Input value={(customField.options || []).join(", ")} placeholder="Options separated by comma"
                        onChange={(e) => updateField(index, { options: e.target.value.split(",").map((item) => item.trim()).filter(Boolean) })} />
                    )}
                  </div>
                ))}
                <Button type="button" variant="outline" size="sm" className="gap-2" onClick={addField}>
                  <Plus className="w-4 h-4" /> Add Question
                </Button>
              </div>
            )}
          </div>
        </div>

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

function parseFields(raw?: string): ApplicationField[] {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}
