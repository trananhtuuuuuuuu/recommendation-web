import { useEffect, useMemo, useState } from "react";
import {
  Award,
  Briefcase,
  Building2,
  CheckCircle2,
  GraduationCap,
  Loader2,
  Mail,
  MapPin,
  Pencil,
  Phone,
  Plus,
  Save,
  Trash2,
  User,
  X,
} from "lucide-react";
import { motion } from "framer-motion";
import { toast } from "sonner";
import { useAuth } from "@/contexts/AuthContext";
import {
  fetchApplicant,
  fetchRecruiter,
  updateApplicant,
  updateRecruiter,
  uploadCv,
  type Applicant,
  type Recruiter,
} from "@/lib/jobsApi";
import { ApiError } from "@/lib/api";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

type TextListField = "skills" | "experience" | "education" | "certifications";

const emptyApplicantForm = {
  userName: "",
  email: "",
  phone: "",
  address: "",
  fullName: "",
  gender: "",
  status: "",
};

const emptyRecruiterForm = {
  userName: "",
  email: "",
  phone: "",
  address: "",
  companyName: "",
  companyDescription: "",
  companyLocation: "",
  companySize: "",
  industry: "",
  website: "",
  logoUrl: "",
  contactEmail: "",
  contactPhone: "",
  taxCode: "",
  businessLicense: "",
  establishedDate: "",
  companyType: "",
};

const emptyCvForm = {
  fullName: "",
  address: "",
  phone: "",
  objective: "",
  skills: [""],
  experience: [""],
  education: [""],
  certifications: [""],
};

export default function Profile() {
  const { user: authUser, role } = useAuth();
  const [applicant, setApplicant] = useState<Applicant | null>(null);
  const [recruiter, setRecruiter] = useState<Recruiter | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editing, setEditing] = useState(false);
  const [applicantForm, setApplicantForm] = useState(emptyApplicantForm);
  const [recruiterForm, setRecruiterForm] = useState(emptyRecruiterForm);
  const [cvForm, setCvForm] = useState(emptyCvForm);

  useEffect(() => {
    if (!authUser?.id) return;
    let active = true;
    setLoading(true);
    const request = role === "RECRUITER" ? fetchRecruiter(authUser.id) : fetchApplicant(authUser.id);

    request
      .then((data) => {
        if (!active) return;
        if (role === "RECRUITER") {
          const next = data as Recruiter;
          setRecruiter(next);
          setRecruiterForm({
            userName: next.userName || authUser.userName || "",
            email: next.email || "",
            phone: next.phone || "",
            address: next.address || "",
            companyName: next.companyName || "",
            companyDescription: next.companyDescription || "",
            companyLocation: next.companyLocation || "",
            companySize: next.companySize || "",
            industry: next.industry || "",
            website: next.website || "",
            logoUrl: next.logoUrl || "",
            contactEmail: next.contactEmail || "",
            contactPhone: next.contactPhone || "",
            taxCode: next.taxCode || "",
            businessLicense: next.businessLicense || "",
            establishedDate: next.establishedDate || "",
            companyType: next.companyType || "",
          });
        } else {
          const next = data as Applicant;
          setApplicant(next);
          setApplicantForm({
            userName: next.userName || authUser.userName || "",
            email: next.email || "",
            phone: next.phone || "",
            address: next.address || "",
            fullName: next.fullName || "",
            gender: next.gender || "",
            status: next.status || "",
          });
          setCvForm({
            fullName: next.cv?.fullName || next.fullName || "",
            address: next.cv?.address || next.address || "",
            phone: next.cv?.phone || next.phone || "",
            objective: next.cv?.objective || "",
            skills: toList(next.cv?.skills),
            experience: toList(next.cv?.experience),
            education: toList(next.cv?.education),
            certifications: toList(next.cv?.certifications),
          });
        }
      })
      .catch((error) => {
        toast.error(error instanceof ApiError ? error.message : "Unable to load profile");
      })
      .finally(() => {
        if (active) setLoading(false);
      });

    return () => {
      active = false;
    };
  }, [authUser?.id, authUser?.userName, role]);

  const applicantHighlights = useMemo(() => {
    const cv = applicant?.cv;
    return [
      { label: "Skills", value: toList(cv?.skills).filter(Boolean).length },
      { label: "Experience", value: toList(cv?.experience).filter(Boolean).length },
      { label: "Education", value: toList(cv?.education).filter(Boolean).length },
      { label: "Certificates", value: toList(cv?.certifications).filter(Boolean).length },
    ];
  }, [applicant]);

  const handleSave = async () => {
    if (!authUser?.id) return;
    setSaving(true);
    try {
      if (role === "RECRUITER") {
        const updated = await updateRecruiter(authUser.id, recruiterForm);
        setRecruiter(updated);
      } else {
        const updated = await updateApplicant(authUser.id, applicantForm);
        await uploadCv(authUser.id, {
          fullName: cvForm.fullName || applicantForm.fullName,
          address: cvForm.address || applicantForm.address,
          phone: cvForm.phone || applicantForm.phone,
          objective: cvForm.objective,
          skills: fromList(cvForm.skills),
          experience: fromList(cvForm.experience),
          education: fromList(cvForm.education),
          certifications: fromList(cvForm.certifications),
        });
        const refreshed = await fetchApplicant(authUser.id);
        setApplicant(refreshed || updated);
      }
      setEditing(false);
      toast.success("Profile updated.");
    } catch (error) {
      toast.error(error instanceof ApiError ? error.message : "Unable to save profile");
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-[55vh] flex items-center justify-center text-muted-foreground">
        <Loader2 className="w-5 h-5 animate-spin" />
      </div>
    );
  }

  if (role === "RECRUITER") {
    return (
      <ProfileShell
        title={recruiter?.companyName || "Recruiter Profile"}
        subtitle={recruiter?.industry || "Company profile and hiring requirements"}
        icon={<Building2 className="w-7 h-7 text-primary" />}
        editing={editing}
        saving={saving}
        onEdit={() => setEditing(true)}
        onCancel={() => setEditing(false)}
        onSave={handleSave}
      >
        {editing ? (
          <RecruiterEditForm form={recruiterForm} setForm={setRecruiterForm} />
        ) : (
          <RecruiterView recruiter={recruiter} />
        )}
      </ProfileShell>
    );
  }

  return (
    <ProfileShell
      title={applicant?.fullName || "Applicant Profile"}
      subtitle={applicant?.status || "Applicant career profile"}
      icon={<User className="w-7 h-7 text-primary" />}
      editing={editing}
      saving={saving}
      onEdit={() => setEditing(true)}
      onCancel={() => setEditing(false)}
      onSave={handleSave}
    >
      {editing ? (
        <ApplicantEditForm
          applicantForm={applicantForm}
          setApplicantForm={setApplicantForm}
          cvForm={cvForm}
          setCvForm={setCvForm}
        />
      ) : (
        <ApplicantView applicant={applicant} highlights={applicantHighlights} />
      )}
    </ProfileShell>
  );
}

function ProfileShell({
  title,
  subtitle,
  icon,
  editing,
  saving,
  onEdit,
  onCancel,
  onSave,
  children,
}: {
  title: string;
  subtitle: string;
  icon: React.ReactNode;
  editing: boolean;
  saving: boolean;
  onEdit: () => void;
  onCancel: () => void;
  onSave: () => void;
  children: React.ReactNode;
}) {
  return (
    <div className="space-y-5">
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <div className="flex items-center gap-4">
          <div className="w-16 h-16 rounded-lg bg-primary/10 flex items-center justify-center">
            {icon}
          </div>
          <div>
            <h1 className="font-display text-2xl font-bold text-foreground">{title}</h1>
            <p className="text-sm text-muted-foreground mt-1">{subtitle}</p>
          </div>
        </div>
        <div className="flex gap-2">
          {editing ? (
            <>
              <Button variant="outline" onClick={onCancel} className="gap-2">
                <X className="w-4 h-4" /> Cancel
              </Button>
              <Button onClick={onSave} disabled={saving} className="gap-2">
                {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                Save
              </Button>
            </>
          ) : (
            <Button onClick={onEdit} className="gap-2">
              <Pencil className="w-4 h-4" /> Edit
            </Button>
          )}
        </div>
      </div>
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        {children}
      </motion.div>
    </div>
  );
}

function ApplicantView({ applicant, highlights }: { applicant: Applicant | null; highlights: { label: string; value: number }[] }) {
  const cv = applicant?.cv;
  return (
    <div className="grid xl:grid-cols-[320px_1fr] gap-5">
      <div className="space-y-5">
        <Panel title="Personal">
          <Info icon={<Mail />} label="Email" value={applicant?.email} />
          <Info icon={<Phone />} label="Phone" value={applicant?.phone} />
          <Info icon={<MapPin />} label="Address" value={applicant?.address} />
          <div className="flex gap-2 pt-2">
            {applicant?.gender && <Badge variant="outline">{applicant.gender}</Badge>}
            {applicant?.status && <Badge>{applicant.status}</Badge>}
          </div>
        </Panel>
        <div className="grid grid-cols-2 gap-3">
          {highlights.map((item) => (
            <div key={item.label} className="rounded-lg border bg-card p-4">
              <p className="text-2xl font-bold text-foreground">{item.value}</p>
              <p className="text-xs text-muted-foreground mt-1">{item.label}</p>
            </div>
          ))}
        </div>
      </div>
      <div className="space-y-5">
        <Panel title="Objective">
          <p className="text-sm text-muted-foreground whitespace-pre-line">{cv?.objective || "No objective has been added yet."}</p>
        </Panel>
        <ListPanel icon={<CheckCircle2 />} title="Skills" values={toList(cv?.skills)} />
        <ListPanel icon={<Briefcase />} title="Experience" values={toList(cv?.experience)} />
        <ListPanel icon={<GraduationCap />} title="Education" values={toList(cv?.education)} />
        <ListPanel icon={<Award />} title="Certificates" values={toList(cv?.certifications)} />
      </div>
    </div>
  );
}

function RecruiterView({ recruiter }: { recruiter: Recruiter | null }) {
  return (
    <div className="grid xl:grid-cols-[360px_1fr] gap-5">
      <div className="space-y-5">
        <Panel title="Company Identity">
          <Info icon={<Building2 />} label="Company" value={recruiter?.companyName} />
          <Info icon={<Briefcase />} label="Industry" value={recruiter?.industry} />
          <Info icon={<UsersIcon />} label="Company Size" value={recruiter?.companySize} />
          <Info icon={<MapPin />} label="Location" value={recruiter?.companyLocation || recruiter?.address} />
        </Panel>
        <Panel title="Contact">
          <Info icon={<Mail />} label="Account Email" value={recruiter?.email} />
          <Info icon={<Phone />} label="Account Phone" value={recruiter?.phone} />
          <Info icon={<Mail />} label="Hiring Email" value={recruiter?.contactEmail} />
          <Info icon={<Phone />} label="Hiring Phone" value={recruiter?.contactPhone} />
        </Panel>
      </div>
      <div className="space-y-5">
        <Panel title="General Hiring Requirements">
          <p className="text-sm text-muted-foreground whitespace-pre-line">
            {recruiter?.companyDescription || "No general requirements have been added yet."}
          </p>
        </Panel>
        <Panel title="Business Details">
          <div className="grid sm:grid-cols-2 gap-4">
            <Info label="Tax Code" value={recruiter?.taxCode} />
            <Info label="Established Date" value={recruiter?.establishedDate} />
            <Info label="Company Type" value={recruiter?.companyType} />
            <Info label="Website" value={recruiter?.website} />
            <Info label="Business License" value={recruiter?.businessLicense} />
          </div>
        </Panel>
      </div>
    </div>
  );
}

function ApplicantEditForm({
  applicantForm,
  setApplicantForm,
  cvForm,
  setCvForm,
}: {
  applicantForm: typeof emptyApplicantForm;
  setApplicantForm: React.Dispatch<React.SetStateAction<typeof emptyApplicantForm>>;
  cvForm: typeof emptyCvForm;
  setCvForm: React.Dispatch<React.SetStateAction<typeof emptyCvForm>>;
}) {
  const setApplicantField = (field: keyof typeof emptyApplicantForm, value: string) => {
    setApplicantForm((current) => ({ ...current, [field]: value }));
  };
  const setCvField = (field: keyof typeof emptyCvForm, value: string) => {
    setCvForm((current) => ({ ...current, [field]: value }));
  };
  const setList = (field: TextListField, values: string[]) => {
    setCvForm((current) => ({ ...current, [field]: values }));
  };

  return (
    <div className="space-y-5">
      <Panel title="Personal Profile">
        <div className="grid md:grid-cols-2 gap-4">
          <Field label="User Name" value={applicantForm.userName} onChange={(value) => setApplicantField("userName", value)} />
          <Field label="Full Name" value={applicantForm.fullName} onChange={(value) => setApplicantField("fullName", value)} />
          <Field label="Email" value={applicantForm.email} onChange={(value) => setApplicantField("email", value)} />
          <Field label="Phone" value={applicantForm.phone} onChange={(value) => setApplicantField("phone", value)} />
          <Field label="Address" value={applicantForm.address} onChange={(value) => setApplicantField("address", value)} />
          <Field label="Gender" value={applicantForm.gender} onChange={(value) => setApplicantField("gender", value)} />
          <Field label="Status" value={applicantForm.status} onChange={(value) => setApplicantField("status", value)} />
        </div>
      </Panel>
      <Panel title="Career Profile">
        <div className="grid md:grid-cols-3 gap-4">
          <Field label="CV Name" value={cvForm.fullName} onChange={(value) => setCvField("fullName", value)} />
          <Field label="CV Phone" value={cvForm.phone} onChange={(value) => setCvField("phone", value)} />
          <Field label="CV Address" value={cvForm.address} onChange={(value) => setCvField("address", value)} />
        </div>
        <div className="mt-4 space-y-2">
          <Label>Objective</Label>
          <Textarea value={cvForm.objective} onChange={(event) => setCvField("objective", event.target.value)} />
        </div>
      </Panel>
      <EditableList title="Skills" values={cvForm.skills} onChange={(values) => setList("skills", values)} placeholder="Java, Spring Boot, React" />
      <EditableList title="Experience" values={cvForm.experience} onChange={(values) => setList("experience", values)} placeholder="Backend Developer at ABC, 2024 - Present" />
      <EditableList title="Education" values={cvForm.education} onChange={(values) => setList("education", values)} placeholder="B.S. Computer Science, HCMUS, 2026" />
      <EditableList title="Certificates" values={cvForm.certifications} onChange={(values) => setList("certifications", values)} placeholder="AWS Cloud Practitioner" />
    </div>
  );
}

function RecruiterEditForm({
  form,
  setForm,
}: {
  form: typeof emptyRecruiterForm;
  setForm: React.Dispatch<React.SetStateAction<typeof emptyRecruiterForm>>;
}) {
  const setField = (field: keyof typeof emptyRecruiterForm, value: string) => {
    setForm((current) => ({ ...current, [field]: value }));
  };

  return (
    <div className="space-y-5">
      <Panel title="Company Identity">
        <div className="grid md:grid-cols-2 gap-4">
          <Field label="Company Name" value={form.companyName} onChange={(value) => setField("companyName", value)} />
          <Field label="Industry" value={form.industry} onChange={(value) => setField("industry", value)} />
          <Field label="Company Size" value={form.companySize} onChange={(value) => setField("companySize", value)} />
          <Field label="Company Type" value={form.companyType} onChange={(value) => setField("companyType", value)} />
          <Field label="Company Location" value={form.companyLocation} onChange={(value) => setField("companyLocation", value)} />
          <Field label="Website" value={form.website} onChange={(value) => setField("website", value)} />
        </div>
        <div className="mt-4 space-y-2">
          <Label>General Hiring Requirements</Label>
          <Textarea value={form.companyDescription} onChange={(event) => setField("companyDescription", event.target.value)} />
        </div>
      </Panel>
      <Panel title="Account And Hiring Contact">
        <div className="grid md:grid-cols-2 gap-4">
          <Field label="User Name" value={form.userName} onChange={(value) => setField("userName", value)} />
          <Field label="Account Email" value={form.email} onChange={(value) => setField("email", value)} />
          <Field label="Account Phone" value={form.phone} onChange={(value) => setField("phone", value)} />
          <Field label="Address" value={form.address} onChange={(value) => setField("address", value)} />
          <Field label="Hiring Email" value={form.contactEmail} onChange={(value) => setField("contactEmail", value)} />
          <Field label="Hiring Phone" value={form.contactPhone} onChange={(value) => setField("contactPhone", value)} />
        </div>
      </Panel>
      <Panel title="Business Verification">
        <div className="grid md:grid-cols-3 gap-4">
          <Field label="Tax Code" value={form.taxCode} onChange={(value) => setField("taxCode", value)} />
          <Field label="Established Date" value={form.establishedDate} onChange={(value) => setField("establishedDate", value)} />
          <Field label="Business License" value={form.businessLicense} onChange={(value) => setField("businessLicense", value)} />
        </div>
      </Panel>
    </div>
  );
}

function EditableList({
  title,
  values,
  onChange,
  placeholder,
}: {
  title: string;
  values: string[];
  onChange: (values: string[]) => void;
  placeholder: string;
}) {
  const updateAt = (index: number, value: string) => {
    onChange(values.map((item, itemIndex) => (itemIndex === index ? value : item)));
  };

  return (
    <Panel title={title}>
      <div className="space-y-3">
        {values.map((value, index) => (
          <div key={index} className="flex gap-2">
            <Input value={value} placeholder={placeholder} onChange={(event) => updateAt(index, event.target.value)} />
            <Button
              type="button"
              variant="outline"
              size="icon"
              onClick={() => onChange(values.length === 1 ? [""] : values.filter((_, itemIndex) => itemIndex !== index))}
            >
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        ))}
        <Button type="button" variant="outline" size="sm" className="gap-2" onClick={() => onChange([...values, ""])}>
          <Plus className="w-4 h-4" /> Add {title}
        </Button>
      </div>
    </Panel>
  );
}

function ListPanel({ icon, title, values }: { icon: React.ReactNode; title: string; values: string[] }) {
  const filtered = values.filter(Boolean);
  return (
    <Panel title={title}>
      {filtered.length === 0 ? (
        <p className="text-sm text-muted-foreground">No {title.toLowerCase()} added yet.</p>
      ) : (
        <div className="grid md:grid-cols-2 gap-3">
          {filtered.map((item) => (
            <div key={item} className="flex items-start gap-3 rounded-lg border bg-secondary/40 p-3">
              <span className="mt-0.5 text-primary [&_svg]:w-4 [&_svg]:h-4">{icon}</span>
              <span className="text-sm text-foreground">{item}</span>
            </div>
          ))}
        </div>
      )}
    </Panel>
  );
}

function Panel({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="rounded-lg border bg-card p-5">
      <h2 className="font-display text-base font-semibold text-foreground mb-4">{title}</h2>
      {children}
    </section>
  );
}

function Field({ label, value, onChange }: { label: string; value?: string; onChange: (value: string) => void }) {
  const id = label.toLowerCase().replace(/\s+/g, "-");
  return (
    <div className="space-y-2">
      <Label htmlFor={id}>{label}</Label>
      <Input id={id} value={value || ""} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}

function Info({ icon, label, value }: { icon?: React.ReactNode; label: string; value?: string | number | null }) {
  return (
    <div className="flex items-start gap-3 py-2">
      {icon && <span className="mt-0.5 text-primary [&_svg]:w-4 [&_svg]:h-4">{icon}</span>}
      <div>
        <p className="text-xs text-muted-foreground">{label}</p>
        <p className="text-sm font-medium text-foreground break-words">{value || "Not provided"}</p>
      </div>
    </div>
  );
}

function toList(value?: string | null) {
  const items = (value || "")
    .split(/\r?\n|,/)
    .map((item) => item.trim())
    .filter(Boolean);
  return items.length > 0 ? items : [""];
}

function fromList(values: string[]) {
  return values.map((item) => item.trim()).filter(Boolean).join("\n");
}

function UsersIcon() {
  return <User className="w-4 h-4" />;
}
