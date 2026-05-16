import { User, Mail, Phone, MapPin, Shield, Lock, Briefcase, GraduationCap, Award, Edit, Eye, EyeOff, Upload, Plus, Trash2, Github } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import { useAuth } from "@/contexts/AuthContext";
import { fetchApplicant, uploadCv, type Applicant } from "@/lib/jobsApi";
import { ApiError } from "@/lib/api";

const profile = {
  fullName: "John Doe",
  email: "j***@email.com",
  phone: "+1 ***-***-4567",
  address: "San Francisco, CA",
  objective: "Experienced software engineer passionate about privacy-preserving technologies. Seeking opportunities to build secure, user-centric applications.",
  skills: ["React", "TypeScript", "Node.js", "Python", "Cryptography", "Privacy Engineering", "Docker", "PostgreSQL"],
  experience: [
    { title: "Senior Developer", company: "TechCorp", period: "2021 - Present", desc: "Led privacy-first frontend architecture for 3 products." },
    { title: "Full Stack Developer", company: "StartupXYZ", period: "2019 - 2021", desc: "Built secure APIs and microservices handling 1M+ requests/day." },
  ],
  education: [
    { degree: "M.S. Computer Science", school: "Stanford University", year: "2019" },
    { degree: "B.S. Software Engineering", school: "UC Berkeley", year: "2017" },
  ],
  certificates: [
    "Certified Information Privacy Professional (CIPP)",
    "AWS Solutions Architect",
    "Google Cloud Professional",
  ],
};

interface EducationEntry {
  schoolName: string;
  time: string;
  major: string;
  gpa: string;
  outstandingSubjects: string;
}

interface WorkEntry {
  companyName: string;
  role: string;
  time: string;
}

export default function Profile() {
  const { user: authUser } = useAuth();
  const [applicant, setApplicant] = useState<Applicant | null>(null);
  const [privacyMode, setPrivacyMode] = useState(true);
  const [showCVForm, setShowCVForm] = useState(false);
  const [cvFile, setCvFile] = useState<File | null>(null);

  // CV form fields
  const [fullName, setFullName] = useState("");
  const [dob, setDob] = useState("");
  const [phone, setPhone] = useState("");
  const [address, setAddress] = useState("");
  const [github, setGithub] = useState("");
  const [gmail, setGmail] = useState("");
  const [technicalSkill, setTechnicalSkill] = useState("");
  const [certificates, setCertificates] = useState("");

  const [educationList, setEducationList] = useState<EducationEntry[]>([
    { schoolName: "", time: "", major: "", gpa: "", outstandingSubjects: "" },
  ]);

  const [workList, setWorkList] = useState<WorkEntry[]>([
    { companyName: "", role: "", time: "" },
  ]);

  useEffect(() => {
    if (!authUser?.id) return;
    let active = true;
    fetchApplicant(authUser.id)
      .then((data) => {
        if (!active) return;
        setApplicant(data);
        setFullName((current) => current || data.fullName || "");
        setPhone((current) => current || data.phone || "");
        setAddress((current) => current || data.address || "");
        setGmail((current) => current || data.email || "");
      })
      .catch(() => {
        /* Non-applicant roles can still view this page shell. */
      });
    return () => { active = false; };
  }, [authUser?.id]);

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) setCvFile(file);
  };

  const addEducation = () => {
    setEducationList([...educationList, { schoolName: "", time: "", major: "", gpa: "", outstandingSubjects: "" }]);
  };

  const removeEducation = (index: number) => {
    if (educationList.length > 1) {
      setEducationList(educationList.filter((_, i) => i !== index));
    }
  };

  const updateEducation = (index: number, field: keyof EducationEntry, value: string) => {
    const updated = [...educationList];
    updated[index][field] = value;
    setEducationList(updated);
  };

  const addWork = () => {
    setWorkList([...workList, { companyName: "", role: "", time: "" }]);
  };

  const removeWork = (index: number) => {
    if (workList.length > 1) {
      setWorkList(workList.filter((_, i) => i !== index));
    }
  };

  const updateWork = (index: number, field: keyof WorkEntry, value: string) => {
    const updated = [...workList];
    updated[index][field] = value;
    setWorkList(updated);
  };

  const handleSubmitCV = async () => {
    if (!authUser?.id) {
      toast.error("Please sign in as an applicant to upload your CV.");
      return;
    }
    try {
      await uploadCv(authUser.id, {
        fullName,
        phone,
        address,
        objective: [
          dob ? `Date of birth: ${dob}` : "",
          github ? `GitHub: ${github}` : "",
          gmail ? `Email: ${gmail}` : "",
        ].filter(Boolean).join("\n"),
        skills: technicalSkill,
        experience: workList
          .filter((work) => work.companyName || work.role || work.time)
          .map((work) => `${work.role || "Role"} at ${work.companyName || "Company"} (${work.time || "N/A"})`)
          .join("\n"),
        education: educationList
          .filter((edu) => edu.schoolName || edu.major || edu.time)
          .map((edu) => `${edu.major || "Major"} at ${edu.schoolName || "School"} (${edu.time || "N/A"})${edu.gpa ? `, GPA ${edu.gpa}` : ""}${edu.outstandingSubjects ? `, ${edu.outstandingSubjects}` : ""}`)
          .join("\n"),
        certifications: [certificates, cvFile?.name ? `Uploaded file: ${cvFile.name}` : ""].filter(Boolean).join("\n"),
      });
      toast.success("CV uploaded.");
      setShowCVForm(false);
    } catch (e) {
      toast.error(e instanceof ApiError ? e.message : "Upload failed");
    }
  };

  const displayProfile = {
    fullName: applicant?.fullName || profile.fullName,
    email: applicant?.email || profile.email,
    phone: applicant?.phone || profile.phone,
    address: applicant?.address || profile.address,
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">My Profile / CV</h1>
          <p className="text-sm text-muted-foreground mt-1">Manage your privacy-protected profile</p>
        </div>
        <div className="flex gap-2 flex-wrap">
          <Button
            variant="outline"
            className="gap-2"
            onClick={() => setShowCVForm(true)}
          >
            <Upload className="w-4 h-4" /> Upload CV
          </Button>
          <Button
            variant="outline"
            className="gap-2"
            onClick={() => setPrivacyMode(!privacyMode)}
          >
            {privacyMode ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            {privacyMode ? "Privacy On" : "Privacy Off"}
          </Button>
          <Button className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2">
            <Edit className="w-4 h-4" /> Edit
          </Button>
        </div>
      </div>

      {/* Upload CV Form Modal */}
      <AnimatePresence>
        {showCVForm && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-foreground/50 z-50 flex items-start justify-center pt-8 px-4 overflow-y-auto"
            onClick={(e) => e.target === e.currentTarget && setShowCVForm(false)}
          >
            <motion.div
              initial={{ opacity: 0, y: 30, scale: 0.97 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 30, scale: 0.97 }}
              className="glass-card rounded-xl p-6 w-full max-w-2xl mb-8"
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="font-display text-xl font-bold text-foreground">Upload Your CV</h2>
                <Button variant="ghost" size="icon" onClick={() => setShowCVForm(false)}>
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>

              {/* File Upload Area */}
              <div className="mb-6">
                <label
                  htmlFor="cv-upload"
                  className="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-primary/30 rounded-xl cursor-pointer hover:border-primary/60 transition-colors bg-primary/5"
                >
                  <Upload className="w-8 h-8 text-primary mb-2" />
                  <span className="text-sm text-muted-foreground">
                    {cvFile ? cvFile.name : "Click to upload your CV (PDF, DOCX)"}
                  </span>
                  <input
                    id="cv-upload"
                    type="file"
                    accept=".pdf,.doc,.docx"
                    className="hidden"
                    onChange={handleFileUpload}
                  />
                </label>
              </div>

              {/* Form Fields */}
              <div className="space-y-5">
                {/* Personal Info */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <Label htmlFor="fullName">Full Name</Label>
                    <Input id="fullName" placeholder="John Doe" value={fullName} onChange={(e) => setFullName(e.target.value)} />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="dob">Date of Birth</Label>
                    <Input id="dob" type="date" value={dob} onChange={(e) => setDob(e.target.value)} />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="phone">Phone</Label>
                    <Input id="phone" placeholder="+1 555-123-4567" value={phone} onChange={(e) => setPhone(e.target.value)} />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="address">Address</Label>
                    <Input id="address" placeholder="San Francisco, CA" value={address} onChange={(e) => setAddress(e.target.value)} />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="github" className="flex items-center gap-1.5">
                      <Github className="w-3.5 h-3.5" /> GitHub Repo
                    </Label>
                    <Input id="github" placeholder="https://github.com/username" value={github} onChange={(e) => setGithub(e.target.value)} />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="gmail" className="flex items-center gap-1.5">
                      <Mail className="w-3.5 h-3.5" /> Gmail
                    </Label>
                    <Input id="gmail" type="email" placeholder="you@gmail.com" value={gmail} onChange={(e) => setGmail(e.target.value)} />
                  </div>
                </div>

                {/* Education */}
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <Label className="text-sm font-semibold flex items-center gap-1.5">
                      <GraduationCap className="w-4 h-4 text-primary" /> Education
                    </Label>
                    <Button variant="ghost" size="sm" className="gap-1 text-xs text-primary" onClick={addEducation}>
                      <Plus className="w-3 h-3" /> Add
                    </Button>
                  </div>
                  <div className="space-y-4">
                    {educationList.map((edu, i) => (
                      <div key={i} className="border border-border rounded-lg p-4 space-y-3 relative">
                        {educationList.length > 1 && (
                          <button
                            onClick={() => removeEducation(i)}
                            className="absolute top-3 right-3 text-muted-foreground hover:text-destructive transition-colors"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        )}
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                          <div className="space-y-1">
                            <Label className="text-xs">School Name</Label>
                            <Input placeholder="Stanford University" value={edu.schoolName} onChange={(e) => updateEducation(i, "schoolName", e.target.value)} />
                          </div>
                          <div className="space-y-1">
                            <Label className="text-xs">Time Period</Label>
                            <Input placeholder="2017 - 2019" value={edu.time} onChange={(e) => updateEducation(i, "time", e.target.value)} />
                          </div>
                          <div className="space-y-1">
                            <Label className="text-xs">Major</Label>
                            <Input placeholder="Computer Science" value={edu.major} onChange={(e) => updateEducation(i, "major", e.target.value)} />
                          </div>
                          <div className="space-y-1">
                            <Label className="text-xs">GPA</Label>
                            <Input placeholder="3.8/4.0" value={edu.gpa} onChange={(e) => updateEducation(i, "gpa", e.target.value)} />
                          </div>
                        </div>
                        <div className="space-y-1">
                          <Label className="text-xs">Outstanding Subjects</Label>
                          <Input placeholder="Data Structures (A+), Algorithms (A), Machine Learning (A+)" value={edu.outstandingSubjects} onChange={(e) => updateEducation(i, "outstandingSubjects", e.target.value)} />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Technical Skills */}
                <div className="space-y-1.5">
                  <Label htmlFor="skills">Technical Skills</Label>
                  <Textarea id="skills" placeholder="React, TypeScript, Node.js, Python, Docker..." value={technicalSkill} onChange={(e) => setTechnicalSkill(e.target.value)} />
                </div>

                {/* Work Experience */}
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <Label className="text-sm font-semibold flex items-center gap-1.5">
                      <Briefcase className="w-4 h-4 text-primary" /> Work Experience
                    </Label>
                    <Button variant="ghost" size="sm" className="gap-1 text-xs text-primary" onClick={addWork}>
                      <Plus className="w-3 h-3" /> Add
                    </Button>
                  </div>
                  <div className="space-y-4">
                    {workList.map((work, i) => (
                      <div key={i} className="border border-border rounded-lg p-4 space-y-3 relative">
                        {workList.length > 1 && (
                          <button
                            onClick={() => removeWork(i)}
                            className="absolute top-3 right-3 text-muted-foreground hover:text-destructive transition-colors"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        )}
                        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                          <div className="space-y-1">
                            <Label className="text-xs">Company Name</Label>
                            <Input placeholder="TechCorp" value={work.companyName} onChange={(e) => updateWork(i, "companyName", e.target.value)} />
                          </div>
                          <div className="space-y-1">
                            <Label className="text-xs">Role</Label>
                            <Input placeholder="Senior Developer" value={work.role} onChange={(e) => updateWork(i, "role", e.target.value)} />
                          </div>
                          <div className="space-y-1">
                            <Label className="text-xs">Time Period</Label>
                            <Input placeholder="2021 - Present" value={work.time} onChange={(e) => updateWork(i, "time", e.target.value)} />
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Certificates */}
                <div className="space-y-1.5">
                  <Label htmlFor="certs" className="flex items-center gap-1.5">
                    <Award className="w-4 h-4 text-primary" /> Certificates
                  </Label>
                  <Textarea id="certs" placeholder="AWS Solutions Architect, Google Cloud Professional..." value={certificates} onChange={(e) => setCertificates(e.target.value)} />
                </div>

                {/* Submit */}
                <div className="flex gap-3 pt-2">
                  <Button className="flex-1 bg-primary text-primary-foreground hover:bg-primary/90" onClick={handleSubmitCV}>
                    Submit CV
                  </Button>
                  <Button variant="outline" onClick={() => setShowCVForm(false)}>
                    Cancel
                  </Button>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Header Card */}
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6">
        <div className="flex items-center gap-5">
          <div className="w-16 h-16 rounded-full bg-primary/15 flex items-center justify-center shield-glow">
            <User className="w-7 h-7 text-primary" />
          </div>
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-1">
              <h2 className="font-display text-xl font-bold text-foreground">{displayProfile.fullName}</h2>
              <Badge className="bg-primary/10 text-primary text-[10px]">
                <Shield className="w-3 h-3 mr-1" /> Verified
              </Badge>
            </div>
            <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
              <span className="flex items-center gap-1"><Mail className="w-3.5 h-3.5" /> {privacyMode ? "Email hidden" : displayProfile.email}</span>
              <span className="flex items-center gap-1"><Phone className="w-3.5 h-3.5" /> {privacyMode ? "Phone hidden" : displayProfile.phone}</span>
              <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {displayProfile.address}</span>
            </div>
          </div>
        </div>
        {privacyMode && (
          <div className="mt-4 flex items-center gap-2 text-xs text-primary bg-primary/5 rounded-lg px-3 py-2">
            <Lock className="w-3 h-3" />
            Privacy mode active — sensitive info is masked from recruiters
          </div>
        )}
      </motion.div>

      {/* Objective */}
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.05 }} className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-2">Objective</h3>
        <p className="text-sm text-muted-foreground leading-relaxed">{profile.objective}</p>
      </motion.div>

      {/* Skills */}
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-3">Skills</h3>
        <div className="flex flex-wrap gap-2">
          {profile.skills.map(s => (
            <span key={s} className="px-3 py-1.5 text-xs font-medium rounded-lg bg-primary/10 text-primary">{s}</span>
          ))}
        </div>
      </motion.div>

      {/* Experience */}
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }} className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-4 flex items-center gap-2">
          <Briefcase className="w-4 h-4 text-primary" /> Experience
        </h3>
        <div className="space-y-4">
          {profile.experience.map((exp, i) => (
            <div key={i} className="border-l-2 border-primary/30 pl-4">
              <h4 className="font-medium text-sm text-foreground">{exp.title}</h4>
              <p className="text-xs text-muted-foreground">{exp.company} · {exp.period}</p>
              <p className="text-sm text-muted-foreground mt-1">{exp.desc}</p>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Education */}
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-4 flex items-center gap-2">
          <GraduationCap className="w-4 h-4 text-primary" /> Education
        </h3>
        <div className="space-y-3">
          {profile.education.map((edu, i) => (
            <div key={i} className="border-l-2 border-primary/30 pl-4">
              <h4 className="font-medium text-sm text-foreground">{edu.degree}</h4>
              <p className="text-xs text-muted-foreground">{edu.school} · {edu.year}</p>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Certificates */}
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 }} className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-3 flex items-center gap-2">
          <Award className="w-4 h-4 text-primary" /> Certificates
        </h3>
        <div className="space-y-2">
          {profile.certificates.map((cert, i) => (
            <div key={i} className="flex items-center gap-2 text-sm text-muted-foreground">
              <div className="w-1.5 h-1.5 rounded-full bg-primary" />
              {cert}
            </div>
          ))}
        </div>
      </motion.div>
    </div>
  );
}
