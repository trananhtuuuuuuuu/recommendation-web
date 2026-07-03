import { useEffect, useMemo, useState } from "react";
import {
  Award,
  Bell,
  Briefcase,
  Building2,
  Calendar,
  Camera,
  Check,
  CheckCircle2,
  ExternalLink,
  FileText,
  Globe,
  GraduationCap,
  Loader2,
  Mail,
  MapPin,
  MessageCircle,
  MoreHorizontal,
  Pencil,
  Phone,
  Plus,
  Save,
  ShieldCheck,
  Sparkles,
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
  analyzeCv,
  updateApplicant,
  updateRecruiter,
  uploadCv,
  type Applicant,
  type CvAnalysis,
  type CvExperienceSuggestion,
  type Recruiter,
} from "@/lib/jobsApi";
import { API_BASE_URL, ApiError } from "@/lib/api";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group";
import {
  avatarFileToDataUrl,
  readProfileAvatar,
  removeProfileAvatar,
  storeProfileAvatar,
} from "@/lib/profileAvatar";

type TextListField = "skills" | "education" | "certifications";

type ExperienceEntry = {
  companyName: string;
  position: string;
  time: string;
  description: string;
  skills: string;
  certificates: string;
};

const createEmptyExperience = (): ExperienceEntry => ({
  companyName: "",
  position: "",
  time: "",
  description: "",
  skills: "",
  certificates: "",
});

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
  coverImageUrl: "",
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
  experience: [createEmptyExperience()],
  education: [""],
  certifications: [""],
  cvFileUrl: "",
};

type ApplicantInlineEditor = keyof typeof emptyApplicantForm | TextListField | "experience" | "objective" | "cvFile";

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
  const [selectedCvFile, setSelectedCvFile] = useState<File | null>(null);
  const [analyzingCv, setAnalyzingCv] = useState(false);
  const [cvAnalysis, setCvAnalysis] = useState<CvAnalysis | null>(null);
  const [activeApplicantEditor, setActiveApplicantEditor] = useState<ApplicantInlineEditor | null>(null);
  const [avatarUrl, setAvatarUrl] = useState("");

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
            email: next.email || authUser.email || "",
            phone: next.phone || "",
            address: next.address || "",
            companyName: next.companyName || "",
            companyDescription: next.companyDescription || "",
            companyLocation: next.companyLocation || "",
            companySize: next.companySize || "",
            industry: next.industry || "",
            website: next.website || "",
            logoUrl: next.logoUrl || "",
            coverImageUrl: next.coverImageUrl || "",
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
            fullName: next.cv?.fullName ?? next.fullName ?? "",
            address: next.cv?.address ?? next.address ?? "",
            phone: next.cv?.phone ?? next.phone ?? "",
            objective: next.cv?.objective ?? "",
            skills: toList(next.cv?.skills),
            experience: toExperienceList(next.cv?.experience),
            education: toList(next.cv?.education),
            certifications: toList(next.cv?.certifications),
            cvFileUrl: next.cv?.cvFileUrl ?? "",
          });
          setSelectedCvFile(null);
          setCvAnalysis(null);
          setActiveApplicantEditor(null);
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
  }, [authUser?.email, authUser?.id, authUser?.userName, role]);

  useEffect(() => {
    setAvatarUrl(readProfileAvatar(role, authUser?.id));
  }, [authUser?.id, role]);

  const handleAvatarUpload = async (file: File) => {
    if (!authUser?.id || !role) return;
    try {
      const nextAvatar = await avatarFileToDataUrl(file);
      storeProfileAvatar(role, authUser.id, nextAvatar);
      setAvatarUrl(nextAvatar);
      toast.success("Profile image updated on this browser.");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Unable to update profile image.");
    }
  };

  const handleAvatarRemove = () => {
    if (!authUser?.id || !role) return;
    removeProfileAvatar(role, authUser.id);
    setAvatarUrl("");
    toast.success("Profile image removed.");
  };

  const applicantHighlights = useMemo(() => {
    const cv = applicant?.cv;
    return [
      { label: "Skills", value: toList(cv?.skills).filter(Boolean).length },
      { label: "Experience", value: toExperienceList(cv?.experience).filter(hasExperienceValue).length },
      { label: "Education", value: toList(cv?.education).filter(Boolean).length },
      { label: "Certificates", value: toList(cv?.certifications).filter(Boolean).length },
    ];
  }, [applicant]);

  const resetApplicantDraft = () => {
    if (!applicant) return;
    setApplicantForm({
      userName: applicant.userName || authUser?.userName || "",
    email: applicant.email || authUser?.email || "",
      phone: applicant.phone || "",
      address: applicant.address || "",
      fullName: applicant.fullName || "",
      gender: applicant.gender || "",
      status: applicant.status || "",
    });
    setCvForm({
      fullName: applicant.cv?.fullName ?? applicant.fullName ?? "",
      address: applicant.cv?.address ?? applicant.address ?? "",
      phone: applicant.cv?.phone ?? applicant.phone ?? "",
      objective: applicant.cv?.objective ?? "",
      skills: toList(applicant.cv?.skills),
      experience: toExperienceList(applicant.cv?.experience),
      education: toList(applicant.cv?.education),
      certifications: toList(applicant.cv?.certifications),
      cvFileUrl: applicant.cv?.cvFileUrl ?? "",
    });
    setSelectedCvFile(null);
    setCvAnalysis(null);
  };

  const handleCvFileChange = async (file: File | null) => {
    setSelectedCvFile(file);
    setCvAnalysis(null);
    if (!file || !authUser?.id) return;

    setAnalyzingCv(true);
    try {
      const analysis = await analyzeCv(authUser.id, file);
      setCvAnalysis(analysis);
      setApplicantForm((current) => ({
        ...current,
        fullName: preferExisting(current.fullName, analysis.fullName),
        email: preferExisting(current.email, analysis.detectedEmail),
        phone: preferExisting(current.phone, analysis.phone),
        address: preferExisting(current.address, analysis.address),
      }));
      setCvForm((current) => ({
        ...current,
        fullName: preferExisting(current.fullName, analysis.fullName),
        phone: preferExisting(current.phone, analysis.phone),
        address: preferExisting(current.address, analysis.address),
        objective: preferExisting(current.objective, analysis.objective),
        skills: mergeDetectedList(current.skills, analysis.skills),
        experience: mergeDetectedExperience(current.experience, analysis.experience),
        education: mergeDetectedList(current.education, analysis.education),
        certifications: mergeDetectedList(current.certifications, analysis.certifications),
      }));
      toast.success(
        analysis.extractionMode === "layoutlmv3"
          ? "CV analyzed with LayoutLMv3. Review the suggested profile fields."
          : "CV text analyzed. Review the suggested profile fields.",
      );
    } catch (error) {
      toast.error(
        error instanceof ApiError
          ? `${error.message}. You can still complete the fields manually.`
          : "Automatic CV analysis failed. You can still upload and complete the fields manually.",
      );
    } finally {
      setAnalyzingCv(false);
    }
  };

  const handleSave = async () => {
    if (!authUser?.id || analyzingCv) return;
    setSaving(true);
    try {
      if (role === "RECRUITER") {
        const updated = await updateRecruiter(authUser.id, recruiterForm);
        setRecruiter(updated);
      } else {
        const updated = await updateApplicant(authUser.id, applicantForm);
        const formData = new FormData();
        formData.append("fullName", cvForm.fullName);
        formData.append("address", cvForm.address);
        formData.append("phone", cvForm.phone);
        formData.append("objective", cvForm.objective);
        formData.append("skills", fromList(cvForm.skills));
        formData.append("experience", fromExperienceList(cvForm.experience));
        formData.append("education", fromList(cvForm.education));
        formData.append("certifications", fromList(cvForm.certifications));
        formData.append("cvFileUrl", cvForm.cvFileUrl);
        if (selectedCvFile) {
          formData.append("cvFile", selectedCvFile);
        }
        await uploadCv(authUser.id, formData);
        const refreshed = await fetchApplicant(authUser.id);
        setApplicant(refreshed || updated);
        setSelectedCvFile(null);
        setCvAnalysis(null);
      }
      setEditing(false);
      setActiveApplicantEditor(null);
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
      <ProfileFrame editing={editing} saving={saving} onEdit={() => setEditing(true)} onCancel={() => setEditing(false)} onSave={handleSave}>
        {editing ? (
          <RecruiterEditForm form={recruiterForm} setForm={setRecruiterForm} />
        ) : (
          <RecruiterView
            recruiter={recruiter}
            avatarUrl={avatarUrl}
            onAvatarUpload={handleAvatarUpload}
            onAvatarRemove={handleAvatarRemove}
            onEdit={() => setEditing(true)}
          />
        )}
      </ProfileFrame>
    );
  }

  return (
    <ProfileFrame
      editing={editing}
      saving={saving || analyzingCv}
      onEdit={() => {
        resetApplicantDraft();
        setEditing(true);
      }}
      onCancel={() => setEditing(false)}
      onSave={handleSave}
    >
      {editing ? (
        <ApplicantEditForm
          applicantForm={applicantForm}
          setApplicantForm={setApplicantForm}
          cvForm={cvForm}
          setCvForm={setCvForm}
          selectedCvFile={selectedCvFile}
          onCvFileChange={handleCvFileChange}
          analyzingCv={analyzingCv}
          cvAnalysis={cvAnalysis}
        />
      ) : (
        <ApplicantView
          applicant={applicant}
          avatarUrl={avatarUrl}
          onAvatarUpload={handleAvatarUpload}
          onAvatarRemove={handleAvatarRemove}
          highlights={applicantHighlights}
          applicantForm={applicantForm}
          setApplicantForm={setApplicantForm}
          cvForm={cvForm}
          setCvForm={setCvForm}
          selectedCvFile={selectedCvFile}
          onCvFileChange={handleCvFileChange}
          analyzingCv={analyzingCv}
          cvAnalysis={cvAnalysis}
          activeEditor={activeApplicantEditor}
          onEdit={(field) => setActiveApplicantEditor(field)}
          onCancel={() => {
            resetApplicantDraft();
            setActiveApplicantEditor(null);
          }}
          onSave={handleSave}
          saving={saving || analyzingCv}
        />
      )}
    </ProfileFrame>
  );
}

function ProfileFrame({
  editing,
  saving,
  onEdit,
  onCancel,
  onSave,
  children,
}: {
  editing: boolean;
  saving: boolean;
  onEdit: () => void;
  onCancel: () => void;
  onSave: () => void;
  children: React.ReactNode;
}) {
  return (
    <div className="mx-auto max-w-6xl space-y-5">
      <div className="flex justify-end gap-2">
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
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        {children}
      </motion.div>
    </div>
  );
}

function ProfileAvatar({
  imageUrl,
  name,
  icon,
}: {
  imageUrl?: string;
  name: string;
  icon: React.ReactNode;
}) {
  return (
    <div className="flex h-16 w-16 shrink-0 items-center justify-center overflow-hidden rounded-xl bg-primary/10 text-primary [&_svg]:h-7 [&_svg]:w-7">
      {imageUrl ? <img src={imageUrl} alt={`${name} profile`} className="h-full w-full object-cover" /> : icon}
    </div>
  );
}

function AvatarActions({
  id,
  hasAvatar,
  onUpload,
  onRemove,
}: {
  id: string;
  hasAvatar: boolean;
  onUpload: (file: File) => void;
  onRemove: () => void;
}) {
  return (
    <div className="mt-4 flex flex-wrap gap-2">
      <Input
        id={id}
        type="file"
        accept="image/png,image/jpeg,image/webp,image/gif"
        className="sr-only"
        onChange={(event) => {
          const file = event.target.files?.[0];
          if (file) onUpload(file);
          event.target.value = "";
        }}
      />
      <Button asChild size="sm" variant="outline" className="gap-2">
        <label htmlFor={id} className="cursor-pointer">
          <Camera className="h-4 w-4" />
          {hasAvatar ? "Replace avatar" : "Upload avatar"}
        </label>
      </Button>
      {hasAvatar ? (
        <Button type="button" size="sm" variant="ghost" onClick={onRemove} className="text-muted-foreground">
          Remove
        </Button>
      ) : null}
      <p className="w-full text-[11px] leading-4 text-muted-foreground">
        PNG, JPG, WebP, or GIF up to 1.5 MB. Stored only in this browser.
      </p>
    </div>
  );
}

function ApplicantView({
  applicant,
  avatarUrl,
  onAvatarUpload,
  onAvatarRemove,
  highlights,
  applicantForm,
  setApplicantForm,
  cvForm,
  setCvForm,
  selectedCvFile,
  onCvFileChange,
  analyzingCv,
  cvAnalysis,
  activeEditor,
  onEdit,
  onCancel,
  onSave,
  saving,
}: {
  applicant: Applicant | null;
  avatarUrl: string;
  onAvatarUpload: (file: File) => void;
  onAvatarRemove: () => void;
  highlights: { label: string; value: number }[];
  applicantForm: typeof emptyApplicantForm;
  setApplicantForm: React.Dispatch<React.SetStateAction<typeof emptyApplicantForm>>;
  cvForm: typeof emptyCvForm;
  setCvForm: React.Dispatch<React.SetStateAction<typeof emptyCvForm>>;
  selectedCvFile: File | null;
  onCvFileChange: (file: File | null) => void;
  analyzingCv: boolean;
  cvAnalysis: CvAnalysis | null;
  activeEditor: ApplicantInlineEditor | null;
  onEdit: (field: ApplicantInlineEditor) => void;
  onCancel: () => void;
  onSave: () => void;
  saving: boolean;
}) {
  const cv = applicant?.cv;
  const title = applicant?.fullName || applicant?.userName || "Applicant Profile";
  const setApplicantField = (field: keyof typeof emptyApplicantForm, value: string) => {
    setApplicantForm((current) => ({ ...current, [field]: value }));
  };
  const setCvField = (field: keyof typeof emptyCvForm, value: string) => {
    setCvForm((current) => ({ ...current, [field]: value }));
  };
  const setList = (field: TextListField, values: string[]) => {
    setCvForm((current) => ({ ...current, [field]: values }));
  };
  const setExperience = (values: ExperienceEntry[]) => {
    setCvForm((current) => ({ ...current, experience: values }));
  };

  return (
    <div className="grid xl:grid-cols-[300px_1fr] gap-5">
      <div className="space-y-5">
        <section className="rounded-lg border bg-card p-5">
          <div className="flex items-start gap-4">
            <ProfileAvatar imageUrl={avatarUrl} name={title} icon={<User />} />
            <div className="min-w-0">
              <h1 className="font-display text-2xl font-bold text-foreground break-words">{title}</h1>
              <p className="text-sm text-muted-foreground mt-1">{applicant?.status || "Career profile"}</p>
            </div>
          </div>
          <AvatarActions
            id="applicant-avatar"
            hasAvatar={Boolean(avatarUrl)}
            onUpload={onAvatarUpload}
            onRemove={onAvatarRemove}
          />
          <div className="mt-4 flex flex-wrap gap-2">
            {applicant?.gender && <Badge variant="outline">{applicant.gender}</Badge>}
            {applicant?.status && <Badge>{applicant.status}</Badge>}
          </div>
        </section>

        <Panel title="Personal">
          <EditableInfo
            icon={<Mail />}
            label="Email"
            value={applicant?.email}
            editing={activeEditor === "email"}
            editor={<Input value={applicantForm.email} onChange={(event) => setApplicantField("email", event.target.value)} />}
            onEdit={() => onEdit("email")}
            onCancel={onCancel}
            onSave={onSave}
            saving={saving}
          />
          <EditableInfo
            icon={<Phone />}
            label="Phone"
            value={applicant?.phone}
            editing={activeEditor === "phone"}
            editor={<Input value={applicantForm.phone} onChange={(event) => setApplicantField("phone", event.target.value)} />}
            onEdit={() => onEdit("phone")}
            onCancel={onCancel}
            onSave={onSave}
            saving={saving}
          />
          <EditableInfo
            icon={<MapPin />}
            label="Address"
            value={applicant?.address}
            editing={activeEditor === "address"}
            editor={<Input value={applicantForm.address} onChange={(event) => setApplicantField("address", event.target.value)} />}
            onEdit={() => onEdit("address")}
            onCancel={onCancel}
            onSave={onSave}
            saving={saving}
          />
          <EditableInfo
            icon={<User />}
            label="Gender"
            value={applicant?.gender}
            editing={activeEditor === "gender"}
            editor={<GenderToggle value={applicantForm.gender} onChange={(value) => setApplicantField("gender", value)} />}
            onEdit={() => onEdit("gender")}
            onCancel={onCancel}
            onSave={onSave}
            saving={saving}
          />
          <EditableInfo
            icon={<CheckCircle2 />}
            label="Open To Work"
            value={applicant?.status}
            editing={activeEditor === "status"}
            editor={<SelectField label="Open To Work Status" value={applicantForm.status} onChange={(value) => setApplicantField("status", value)} options={["OpenToWork", "Normal"]} hideLabel />}
            onEdit={() => onEdit("status")}
            onCancel={onCancel}
            onSave={onSave}
            saving={saving}
          />
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
        <Panel title="Objective" action={activeEditor !== "objective" && <IconButton label="Edit objective" onClick={() => onEdit("objective")} icon={<Pencil />} />}>
          {activeEditor === "objective" ? (
            <InlineEditorActions onCancel={onCancel} onSave={onSave} saving={saving}>
              <Textarea value={cvForm.objective} onChange={(event) => setCvField("objective", event.target.value)} />
            </InlineEditorActions>
          ) : (
            <p className="text-sm text-muted-foreground whitespace-pre-line">{cv?.objective || "No objective has been added yet."}</p>
          )}
        </Panel>

        <Panel title="CV File" action={activeEditor !== "cvFile" && <IconButton label="Edit CV file" onClick={() => onEdit("cvFile")} icon={<Pencil />} />}>
          {activeEditor === "cvFile" ? (
            <InlineEditorActions onCancel={onCancel} onSave={onSave} saving={saving}>
              <Input
                type="file"
                accept=".pdf,.doc,.docx,.png,.jpg,.jpeg,.webp,.bmp,.tif,.tiff,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,image/png,image/jpeg,image/webp,image/bmp,image/tiff"
                disabled={analyzingCv}
                onChange={(event) => onCvFileChange(event.target.files?.[0] ?? null)}
              />
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <FileText className="w-4 h-4 text-primary" />
                <span className="break-all">
                  {selectedCvFile?.name || fileNameFromPath(cvForm.cvFileUrl) || "No CV file selected yet."}
                </span>
              </div>
              <CvAnalysisNotice analyzing={analyzingCv} analysis={cvAnalysis} />
            </InlineEditorActions>
          ) : cv?.cvFileUrl ? (
            <a href={toAssetUrl(cv.cvFileUrl)} target="_blank" rel="noreferrer" className="inline-flex items-center gap-2 text-sm font-medium text-primary underline underline-offset-4">
              <FileText className="w-4 h-4" /> Open uploaded CV
            </a>
          ) : (
            <p className="text-sm text-muted-foreground">No CV file reference has been added yet.</p>
          )}
        </Panel>

        <LinkedInListPanel icon={<CheckCircle2 />} title="Skills" values={toList(cv?.skills)} editKey="skills" editing={activeEditor === "skills"} editValues={cvForm.skills} onEdit={() => onEdit("skills")} onChange={(values) => setList("skills", values)} onCancel={onCancel} onSave={onSave} saving={saving} placeholder="Java, Spring Boot, React" />
        <ExperiencePanel values={toExperienceList(cv?.experience)} editing={activeEditor === "experience"} editValues={cvForm.experience} onEdit={() => onEdit("experience")} onChange={setExperience} onCancel={onCancel} onSave={onSave} saving={saving} />
        <LinkedInListPanel icon={<GraduationCap />} title="Education" values={toList(cv?.education)} editKey="education" editing={activeEditor === "education"} editValues={cvForm.education} onEdit={() => onEdit("education")} onChange={(values) => setList("education", values)} onCancel={onCancel} onSave={onSave} saving={saving} placeholder="VNUHCM - University of Science - Bachelor of Computer Science" />
        <LinkedInListPanel icon={<Award />} title="Certificates" values={toList(cv?.certifications)} editKey="certifications" editing={activeEditor === "certifications"} editValues={cvForm.certifications} onEdit={() => onEdit("certifications")} onChange={(values) => setList("certifications", values)} onCancel={onCancel} onSave={onSave} saving={saving} placeholder="AWS Cloud Practitioner" />
      </div>
    </div>
  );
}

function RecruiterView({
  recruiter,
  avatarUrl,
  onAvatarUpload,
  onAvatarRemove,
  onEdit,
}: {
  recruiter: Recruiter | null;
  avatarUrl: string;
  onAvatarUpload: (file: File) => void;
  onAvatarRemove: () => void;
  onEdit: () => void;
}) {
  const companyName = recruiter?.companyName || "Recruiter Company";
  const location = recruiter?.companyLocation || recruiter?.address || "Location not provided";
  const description = recruiter?.companyDescription || "No company overview has been added yet.";
  return (
    <div className="space-y-4">
      <section className="overflow-hidden rounded-lg border bg-card">
        <div
          className="h-40 sm:h-48 bg-[linear-gradient(135deg,hsl(var(--primary)),hsl(var(--trust)),hsl(var(--accent)))]"
          style={recruiter?.coverImageUrl ? { backgroundImage: `url(${recruiter.coverImageUrl})`, backgroundSize: "cover", backgroundPosition: "center" } : undefined}
        />
        <div className="px-5 pb-5">
          <div className="-mt-16 flex items-start justify-between gap-4">
            <div className="w-28 h-28 rounded-xl border-4 border-card bg-secondary overflow-hidden shadow-sm flex items-center justify-center shrink-0">
              {avatarUrl || recruiter?.logoUrl ? (
                <img src={avatarUrl || recruiter?.logoUrl} alt={companyName} className="w-full h-full object-cover" />
              ) : (
                <Building2 className="w-11 h-11 text-primary" />
              )}
            </div>
            <IconButton label="Edit recruiter profile" onClick={onEdit} icon={<Pencil />} className="mt-16" />
          </div>

          <div className="mt-4 max-w-3xl">
            <div className="flex items-center gap-2">
              <h1 className="font-display text-3xl font-bold text-foreground">{companyName}</h1>
              <ShieldCheck className="w-5 h-5 text-muted-foreground" />
            </div>
            <p className="mt-2 text-sm text-foreground">{description}</p>
            <p className="mt-2 text-sm text-muted-foreground">
              {[recruiter?.industry, location, recruiter?.companySize].filter(Boolean).join(" - ") || "Company details not provided"}
            </p>
          </div>

          <AvatarActions
            id="recruiter-avatar"
            hasAvatar={Boolean(avatarUrl)}
            onUpload={onAvatarUpload}
            onRemove={onAvatarRemove}
          />

          <div className="mt-5 flex flex-wrap gap-2">
            <Button className="gap-2 rounded-full">
              <MessageCircle className="w-4 h-4" /> Message
            </Button>
            <Button variant="outline" className="gap-2 rounded-full">
              <Check className="w-4 h-4" /> Following
            </Button>
            <Button variant="outline" size="icon" className="rounded-full">
              <MoreHorizontal className="w-4 h-4" />
            </Button>
          </div>
        </div>

        <Tabs defaultValue="home" className="border-t">
          <TabsList className="h-auto w-full justify-start rounded-none bg-transparent p-0 px-5">
            {["home", "about", "posts", "jobs"].map((tab) => (
              <TabsTrigger
                key={tab}
                value={tab}
                className="rounded-none border-b-2 border-transparent px-4 py-4 capitalize shadow-none data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:text-primary data-[state=active]:shadow-none"
              >
                {tab}
              </TabsTrigger>
            ))}
          </TabsList>
          <div className="p-5">
            <TabsContent value="home" className="mt-0">
              <RecruiterHome recruiter={recruiter} />
            </TabsContent>
            <TabsContent value="about" className="mt-0">
              <RecruiterAbout recruiter={recruiter} />
            </TabsContent>
            <TabsContent value="posts" className="mt-0">
              <EmptyState icon={<Bell />} title="No company posts yet" />
            </TabsContent>
            <TabsContent value="jobs" className="mt-0">
              <EmptyState icon={<Briefcase />} title="Posted jobs will appear here" />
            </TabsContent>
          </div>
        </Tabs>
      </section>
    </div>
  );
}

function RecruiterHome({ recruiter }: { recruiter: Recruiter | null }) {
  return (
    <div className="grid lg:grid-cols-[1fr_320px] gap-5">
      <Panel title="Overview">
        <p className="text-sm leading-6 text-muted-foreground whitespace-pre-line">
          {recruiter?.companyDescription || "No company overview has been added yet."}
        </p>
      </Panel>
      <Panel title="Page Details">
        <Info icon={<Building2 />} label="Industry" value={recruiter?.industry} />
        <Info icon={<MapPin />} label="Location" value={recruiter?.companyLocation || recruiter?.address} />
        <Info icon={<UsersIcon />} label="Company Size" value={recruiter?.companySize} />
        <Info icon={<Globe />} label="Website" value={recruiter?.website} />
      </Panel>
    </div>
  );
}

function RecruiterAbout({ recruiter }: { recruiter: Recruiter | null }) {
  return (
    <div className="grid md:grid-cols-2 gap-5">
      <Panel title="Contact">
        <Info icon={<Mail />} label="Account Email" value={recruiter?.email} />
        <Info icon={<Phone />} label="Account Phone" value={recruiter?.phone} />
        <Info icon={<Mail />} label="Hiring Email" value={recruiter?.contactEmail} />
        <Info icon={<Phone />} label="Hiring Phone" value={recruiter?.contactPhone} />
      </Panel>
      <Panel title="Business Details">
        <Info icon={<FileText />} label="Tax Code" value={recruiter?.taxCode} />
        <Info icon={<Calendar />} label="Established Date" value={recruiter?.establishedDate} />
        <Info icon={<Building2 />} label="Company Type" value={recruiter?.companyType} />
        <Info icon={<ExternalLink />} label="Business License" value={recruiter?.businessLicense} />
      </Panel>
    </div>
  );
}

function ApplicantEditForm({
  applicantForm,
  setApplicantForm,
  cvForm,
  setCvForm,
  selectedCvFile,
  onCvFileChange,
  analyzingCv,
  cvAnalysis,
}: {
  applicantForm: typeof emptyApplicantForm;
  setApplicantForm: React.Dispatch<React.SetStateAction<typeof emptyApplicantForm>>;
  cvForm: typeof emptyCvForm;
  setCvForm: React.Dispatch<React.SetStateAction<typeof emptyCvForm>>;
  selectedCvFile: File | null;
  onCvFileChange: (file: File | null) => void;
  analyzingCv: boolean;
  cvAnalysis: CvAnalysis | null;
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
  const setExperience = (values: ExperienceEntry[]) => {
    setCvForm((current) => ({ ...current, experience: values }));
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
          <GenderToggle value={applicantForm.gender} onChange={(value) => setApplicantField("gender", value)} showLabel />
          <SelectField label="Open To Work Status" value={applicantForm.status} onChange={(value) => setApplicantField("status", value)} options={["OpenToWork", "Normal"]} />
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
        <div className="mt-4 space-y-2">
          <Label htmlFor="cv-file">CV File</Label>
          <Input
            id="cv-file"
            type="file"
            accept=".pdf,.doc,.docx,.png,.jpg,.jpeg,.webp,.bmp,.tif,.tiff,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,image/png,image/jpeg,image/webp,image/bmp,image/tiff"
            disabled={analyzingCv}
            onChange={(event) => onCvFileChange(event.target.files?.[0] ?? null)}
          />
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <FileText className="w-4 h-4 text-primary" />
            <span className="break-all">
              {selectedCvFile?.name || fileNameFromPath(cvForm.cvFileUrl) || "No CV file selected yet."}
            </span>
          </div>
          <CvAnalysisNotice analyzing={analyzingCv} analysis={cvAnalysis} />
        </div>
      </Panel>

      <EditableList title="Skills" values={cvForm.skills} onChange={(values) => setList("skills", values)} placeholder="Java, Spring Boot, React" />
      <EditableExperience title="Experience" values={cvForm.experience} onChange={setExperience} />
      <EditableList title="Education" values={cvForm.education} onChange={(values) => setList("education", values)} placeholder="VNUHCM - University of Science - Bachelor of Computer Science" />
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
          <Field label="Logo URL" value={form.logoUrl} onChange={(value) => setField("logoUrl", value)} />
          <Field label="Cover Image URL" value={form.coverImageUrl} onChange={(value) => setField("coverImageUrl", value)} />
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
  return (
    <Panel title={title}>
      <EditableListFields values={values} onChange={onChange} placeholder={placeholder} title={title} />
    </Panel>
  );
}

function EditableListFields({
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
  );
}

function EditableExperience({
  title,
  values,
  onChange,
}: {
  title: string;
  values: ExperienceEntry[];
  onChange: (values: ExperienceEntry[]) => void;
}) {
  return (
    <Panel title={title}>
      <EditableExperienceFields values={values} onChange={onChange} />
    </Panel>
  );
}

function EditableExperienceFields({
  values,
  onChange,
}: {
  values: ExperienceEntry[];
  onChange: (values: ExperienceEntry[]) => void;
}) {
  const entries = values.length > 0 ? values : [createEmptyExperience()];
  const updateAt = (index: number, field: keyof ExperienceEntry, value: string) => {
    onChange(entries.map((item, itemIndex) => (itemIndex === index ? { ...item, [field]: value } : item)));
  };
  const removeAt = (index: number) => {
    onChange(entries.length === 1 ? [createEmptyExperience()] : entries.filter((_, itemIndex) => itemIndex !== index));
  };

  return (
    <div className="space-y-4">
      {entries.map((entry, index) => (
        <div key={index} className="border-l pl-4">
          <div className="flex items-center justify-between gap-3">
            <p className="text-sm font-semibold text-foreground">Experience {index + 1}</p>
            <Button type="button" variant="ghost" size="icon" onClick={() => removeAt(index)} aria-label="Remove experience">
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
          <div className="mt-3 grid md:grid-cols-2 gap-3">
            <Field label="Company Name" value={entry.companyName} onChange={(value) => updateAt(index, "companyName", value)} />
            <Field label="Position" value={entry.position} onChange={(value) => updateAt(index, "position", value)} />
            <Field label="Time" value={entry.time} onChange={(value) => updateAt(index, "time", value)} />
            <Field label="Skills Learned" value={entry.skills} onChange={(value) => updateAt(index, "skills", value)} />
          </div>
          <div className="mt-3 space-y-2">
            <Label>Description</Label>
            <Textarea value={entry.description} onChange={(event) => updateAt(index, "description", event.target.value)} />
          </div>
          <div className="mt-3">
            <Field label="Certificates" value={entry.certificates} onChange={(value) => updateAt(index, "certificates", value)} />
          </div>
        </div>
      ))}
      <Button type="button" variant="outline" size="sm" className="gap-2" onClick={() => onChange([...entries, createEmptyExperience()])}>
        <Plus className="w-4 h-4" /> Add Experience
      </Button>
    </div>
  );
}

function ExperiencePanel({
  values,
  editing,
  editValues,
  onEdit,
  onChange,
  onCancel,
  onSave,
  saving,
}: {
  values: ExperienceEntry[];
  editing: boolean;
  editValues: ExperienceEntry[];
  onEdit: () => void;
  onChange: (values: ExperienceEntry[]) => void;
  onCancel: () => void;
  onSave: () => void;
  saving: boolean;
}) {
  const filtered = values.filter(hasExperienceValue);
  return (
    <Panel
      title="Experience"
      action={
        !editing && <div className="flex gap-1">
          <IconButton label="Add Experience" onClick={onEdit} icon={<Plus />} />
          <IconButton label="Edit Experience" onClick={onEdit} icon={<Pencil />} />
        </div>
      }
    >
      {editing ? (
        <InlineEditorActions onCancel={onCancel} onSave={onSave} saving={saving}>
          <EditableExperienceFields values={editValues} onChange={onChange} />
        </InlineEditorActions>
      ) : filtered.length === 0 ? (
        <p className="text-sm text-muted-foreground">No experience added yet.</p>
      ) : (
        <div className="space-y-4">
          {filtered.map((item, index) => (
            <div key={`${item.companyName}-${item.position}-${index}`} className="flex items-start gap-3">
              <span className="mt-1 flex h-10 w-10 shrink-0 items-center justify-center rounded-sm border bg-secondary text-primary">
                <Briefcase className="w-5 h-5" />
              </span>
              <div className="min-w-0 space-y-1">
                <p className="text-sm font-semibold text-foreground break-words">
                  {[item.position, item.companyName].filter(Boolean).join(" at ") || "Experience"}
                </p>
                {item.time && <p className="text-xs text-muted-foreground">{item.time}</p>}
                {item.description && <p className="text-sm leading-6 text-muted-foreground whitespace-pre-line">{item.description}</p>}
                {item.skills && <p className="text-sm text-muted-foreground"><span className="font-medium text-foreground">Skills:</span> {item.skills}</p>}
                {item.certificates && <p className="text-sm text-muted-foreground"><span className="font-medium text-foreground">Certificates:</span> {item.certificates}</p>}
              </div>
            </div>
          ))}
        </div>
      )}
    </Panel>
  );
}

function LinkedInListPanel({
  icon,
  title,
  values,
  editing,
  editValues,
  onEdit,
  onChange,
  onCancel,
  onSave,
  saving,
  placeholder,
}: {
  icon: React.ReactNode;
  title: string;
  values: string[];
  editKey: TextListField;
  editing: boolean;
  editValues: string[];
  onEdit: () => void;
  onChange: (values: string[]) => void;
  onCancel: () => void;
  onSave: () => void;
  saving: boolean;
  placeholder: string;
}) {
  const filtered = values.filter(Boolean);
  return (
    <Panel
      title={title}
      action={
        !editing && <div className="flex gap-1">
          <IconButton label={`Add ${title}`} onClick={onEdit} icon={<Plus />} />
          <IconButton label={`Edit ${title}`} onClick={onEdit} icon={<Pencil />} />
        </div>
      }
    >
      {editing ? (
        <InlineEditorActions onCancel={onCancel} onSave={onSave} saving={saving}>
          <EditableListFields title={title} values={editValues} onChange={onChange} placeholder={placeholder} />
        </InlineEditorActions>
      ) : filtered.length === 0 ? (
        <p className="text-sm text-muted-foreground">No {title.toLowerCase()} added yet.</p>
      ) : (
        <div className="space-y-4">
          {filtered.map((item) => (
            <div key={item} className="flex items-start gap-3">
              <span className="mt-1 flex h-10 w-10 shrink-0 items-center justify-center rounded-sm border bg-secondary text-primary [&_svg]:w-5 [&_svg]:h-5">
                {icon}
              </span>
              <div className="min-w-0">
                <p className="text-sm font-semibold text-foreground whitespace-pre-line">{firstLine(item)}</p>
                {restLines(item) && <p className="mt-1 text-sm leading-6 text-muted-foreground whitespace-pre-line">{restLines(item)}</p>}
              </div>
            </div>
          ))}
        </div>
      )}
    </Panel>
  );
}

function Panel({
  title,
  action,
  children,
}: {
  title: string;
  action?: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <section className="rounded-lg border bg-card p-5">
      <div className="mb-4 flex items-center justify-between gap-3">
        <h2 className="font-display text-base font-semibold text-foreground">{title}</h2>
        {action}
      </div>
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

function GenderToggle({
  value,
  onChange,
  showLabel = false,
}: {
  value?: string;
  onChange: (value: string) => void;
  showLabel?: boolean;
}) {
  return (
    <div className="space-y-2">
      {showLabel ? <Label>Gender</Label> : null}
      <ToggleGroup
        type="single"
        value={value || ""}
        onValueChange={(nextValue) => {
          if (nextValue) onChange(nextValue);
        }}
        variant="outline"
        className="grid w-full grid-cols-3 rounded-lg bg-secondary/40 p-1"
        aria-label="Choose gender"
      >
        {["Male", "Female", "Other"].map((option) => (
          <ToggleGroupItem
            key={option}
            value={option}
            aria-label={option}
            className="w-full data-[state=on]:bg-primary data-[state=on]:text-primary-foreground"
          >
            {option}
          </ToggleGroupItem>
        ))}
      </ToggleGroup>
    </div>
  );
}

function SelectField({
  label,
  value,
  options,
  onChange,
  hideLabel = false,
}: {
  label: string;
  value?: string;
  options: string[];
  onChange: (value: string) => void;
  hideLabel?: boolean;
}) {
  return (
    <div className="space-y-2">
      {!hideLabel && <Label>{label}</Label>}
      <div className="flex gap-2">
        <Select value={value || undefined} onValueChange={onChange}>
          <SelectTrigger>
            <SelectValue placeholder={`Select ${label.toLowerCase()}`} />
          </SelectTrigger>
          <SelectContent>
            {options.map((option) => (
              <SelectItem key={option} value={option}>
                {option}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        {value && (
          <Button type="button" variant="outline" size="icon" aria-label={`Clear ${label}`} onClick={() => onChange("")}>
            <X className="w-4 h-4" />
          </Button>
        )}
      </div>
    </div>
  );
}

function Info({ icon, label, value }: { icon?: React.ReactNode; label: string; value?: string | number | null }) {
  return (
    <div className="flex items-start gap-3 py-2">
      {icon && <span className="mt-0.5 text-primary [&_svg]:w-4 [&_svg]:h-4">{icon}</span>}
      <div className="min-w-0">
        <p className="text-xs text-muted-foreground">{label}</p>
        <p className="text-sm font-medium text-foreground break-words">{value || "Not provided"}</p>
      </div>
    </div>
  );
}

function EditableInfo({
  icon,
  label,
  value,
  editing,
  editor,
  onEdit,
  onCancel,
  onSave,
  saving,
}: {
  icon?: React.ReactNode;
  label: string;
  value?: string | number | null;
  editing: boolean;
  editor: React.ReactNode;
  onEdit: () => void;
  onCancel: () => void;
  onSave: () => void;
  saving: boolean;
}) {
  if (editing) {
    return (
      <div className="py-2">
        <div className="flex items-start gap-3">
          {icon && <span className="mt-2 text-primary [&_svg]:w-4 [&_svg]:h-4">{icon}</span>}
          <div className="min-w-0 flex-1 space-y-2">
            <p className="text-xs text-muted-foreground">{label}</p>
            <InlineEditorActions onCancel={onCancel} onSave={onSave} saving={saving}>
              {editor}
            </InlineEditorActions>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="flex items-start justify-between gap-3 py-2">
      <Info icon={icon} label={label} value={value} />
      <IconButton label={`Edit ${label}`} onClick={onEdit} icon={<Pencil />} />
    </div>
  );
}

function InlineEditorActions({
  children,
  onCancel,
  onSave,
  saving,
}: {
  children: React.ReactNode;
  onCancel: () => void;
  onSave: () => void;
  saving: boolean;
}) {
  return (
    <div className="space-y-3">
      {children}
      <div className="flex justify-end gap-2">
        <Button type="button" variant="outline" size="sm" onClick={onCancel} className="gap-2">
          <X className="w-4 h-4" /> Cancel
        </Button>
        <Button type="button" size="sm" onClick={onSave} disabled={saving} className="gap-2">
          {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
          Save
        </Button>
      </div>
    </div>
  );
}

function IconButton({
  label,
  onClick,
  icon,
  className = "",
}: {
  label: string;
  onClick: () => void;
  icon: React.ReactNode;
  className?: string;
}) {
  return (
    <Button type="button" variant="ghost" size="icon" aria-label={label} title={label} onClick={onClick} className={className}>
      <span className="[&_svg]:w-4 [&_svg]:h-4">{icon}</span>
    </Button>
  );
}

function EmptyState({ icon, title }: { icon: React.ReactNode; title: string }) {
  return (
    <div className="flex items-center gap-3 rounded-lg border border-dashed p-5 text-muted-foreground">
      <span className="[&_svg]:w-5 [&_svg]:h-5">{icon}</span>
      <p className="text-sm">{title}</p>
    </div>
  );
}

function CvAnalysisNotice({
  analyzing,
  analysis,
}: {
  analyzing: boolean;
  analysis: CvAnalysis | null;
}) {
  if (analyzing) {
    return (
      <div className="flex items-center gap-2 rounded-lg border border-primary/20 bg-primary/5 px-3 py-2 text-xs text-muted-foreground">
        <Loader2 className="h-4 w-4 animate-spin text-primary" />
        Analyzing your CV and preparing profile suggestions...
      </div>
    );
  }

  if (!analysis) {
    return (
      <p className="text-xs text-muted-foreground">
        Selecting a CV suggests values for empty profile fields. Existing information is preserved.
      </p>
    );
  }

  const modeLabel = analysis.extractionMode === "layoutlmv3" ? "LayoutLMv3" : "Text extraction";
  const confidenceLabel =
    typeof analysis.confidence === "number"
      ? `${Math.round(analysis.confidence * 100)}% confidence`
      : null;

  return (
    <div className="rounded-lg border border-primary/20 bg-primary/5 p-3 text-xs">
      <div className="flex flex-wrap items-center gap-2">
        <Sparkles className="h-4 w-4 text-primary" />
        <span className="font-medium text-foreground">CV suggestions applied to empty fields</span>
        <Badge variant="secondary">{modeLabel}</Badge>
        {confidenceLabel && <span className="text-muted-foreground">{confidenceLabel}</span>}
      </div>
      {analysis.warnings && analysis.warnings.length > 0 && (
        <p className="mt-2 text-muted-foreground">{analysis.warnings.join(" ")}</p>
      )}
    </div>
  );
}

function preferExisting(current: string, detected?: string | null) {
  return current.trim() ? current : detected?.trim() ?? "";
}

function mergeDetectedList(existing: string[], detected?: string[] | null) {
  const result = existing.map((value) => value.trim()).filter(Boolean);
  const knownValues = new Set(result.map((value) => value.toLowerCase()));

  for (const value of detected ?? []) {
    const cleanedValue = value.trim();
    const normalizedValue = cleanedValue.toLowerCase();
    if (cleanedValue && !knownValues.has(normalizedValue)) {
      result.push(cleanedValue);
      knownValues.add(normalizedValue);
    }
  }

  return result.length ? result : [""];
}

function mergeDetectedExperience(
  existing: ExperienceEntry[],
  detected?: CvExperienceSuggestion[] | null,
) {
  const result = existing
    .map((entry) => ({
      companyName: entry.companyName.trim(),
      position: entry.position.trim(),
      time: entry.time.trim(),
      description: entry.description.trim(),
      skills: entry.skills.trim(),
      certificates: entry.certificates.trim(),
    }))
    .filter(hasExperienceValue);
  const knownValues = new Set(result.map(experienceKey));

  for (const entry of detected ?? []) {
    const suggestion: ExperienceEntry = {
      companyName: entry.companyName?.trim() ?? "",
      position: entry.position?.trim() ?? "",
      time: entry.time?.trim() ?? "",
      description: entry.description?.trim() ?? "",
      skills: entry.skills?.trim() ?? "",
      certificates: entry.certificates?.trim() ?? "",
    };
    const key = experienceKey(suggestion);
    if (hasExperienceValue(suggestion) && !knownValues.has(key)) {
      result.push(suggestion);
      knownValues.add(key);
    }
  }

  return result.length ? result : [createEmptyExperience()];
}

function experienceKey(entry: ExperienceEntry) {
  return Object.values(entry)
    .map((value) => value.trim().toLowerCase())
    .join("|");
}

function toList(value?: string | string[] | null) {
  if (Array.isArray(value)) {
    const items = value.map((item) => item.trim()).filter(Boolean);
    return items.length > 0 ? items : [""];
  }
  const items = (value || "")
    .split(/\r?\n|,/)
    .map((item) => item.trim())
    .filter(Boolean);
  return items.length > 0 ? items : [""];
}

function fromList(values: string[]) {
  return values.map((item) => item.trim()).filter(Boolean).join("\n");
}

function toExperienceList(value?: string | null): ExperienceEntry[] {
  if (!value?.trim()) return [createEmptyExperience()];
  try {
    const parsed = JSON.parse(value);
    if (Array.isArray(parsed)) {
      const entries = parsed.map((item) => ({
        companyName: String(item?.companyName ?? ""),
        position: String(item?.position ?? ""),
        time: String(item?.time ?? ""),
        description: String(item?.description ?? ""),
        skills: Array.isArray(item?.skills) ? item.skills.join(", ") : String(item?.skills ?? ""),
        certificates: Array.isArray(item?.certificates) ? item.certificates.join(", ") : String(item?.certificates ?? ""),
      }));
      return entries.length > 0 ? entries : [createEmptyExperience()];
    }
  } catch {
    // Plain text experience from older CVs is converted into one editable entry.
  }
  const legacyEntries = toList(value)
    .filter(Boolean)
    .map((description) => ({ ...createEmptyExperience(), description }));
  return legacyEntries.length > 0 ? legacyEntries : [createEmptyExperience()];
}

function fromExperienceList(values: ExperienceEntry[]) {
  const entries = values
    .map((item) => ({
      companyName: item.companyName.trim(),
      position: item.position.trim(),
      time: item.time.trim(),
      description: item.description.trim(),
      skills: item.skills.trim(),
      certificates: item.certificates.trim(),
    }))
    .filter(hasExperienceValue);
  return entries.length > 0 ? JSON.stringify(entries) : "";
}

function hasExperienceValue(value: ExperienceEntry) {
  return Object.values(value).some((item) => item.trim().length > 0);
}

function firstLine(value: string) {
  return value.split(/\r?\n/)[0] || value;
}

function restLines(value: string) {
  return value.split(/\r?\n/).slice(1).join("\n");
}

function fileNameFromPath(value?: string | null) {
  if (!value) return "";
  return value.split("/").filter(Boolean).pop() || value;
}

function toAssetUrl(value: string) {
  if (/^https?:\/\//i.test(value)) return value;
  return `${API_BASE_URL}${value.startsWith("/") ? value : `/${value}`}`;
}

function UsersIcon() {
  return <User className="w-4 h-4" />;
}
