import { useParams, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { User, Mail, Phone, MapPin, Shield, ArrowLeft, Edit, Briefcase, GraduationCap, Award } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useState } from "react";

const mockApplicant = {
  id: "1",
  fullName: "Jane Smith",
  email: "j***@email.com",
  phone: "+1 ***-***-1234",
  address: "Boston, MA",
  status: "Active",
  objective: "Privacy-aware engineer seeking impactful roles.",
  skills: ["React", "Node.js", "Cryptography"],
  experience: [{ title: "Engineer", company: "Acme", period: "2022 - Present" }],
  education: [{ degree: "B.S. CS", school: "MIT", year: "2022" }],
  certificates: ["CIPP"],
};

export default function ApplicantDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [editMode, setEditMode] = useState(false);

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
          <ArrowLeft className="w-4 h-4" /> Back
        </Button>
        <Button size="sm" onClick={() => setEditMode(!editMode)} className="gap-1 bg-primary text-primary-foreground">
          <Edit className="w-3.5 h-3.5" /> {editMode ? "Cancel" : "Edit Profile"}
        </Button>
      </div>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6">
        <div className="flex items-center gap-5">
          <div className="w-16 h-16 rounded-full bg-primary/15 flex items-center justify-center"><User className="w-7 h-7 text-primary" /></div>
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-1">
              <h2 className="font-display text-xl font-bold text-foreground">{mockApplicant.fullName}</h2>
              <Badge className="bg-primary/10 text-primary text-[10px]"><Shield className="w-3 h-3 mr-1" />ID: {id}</Badge>
            </div>
            <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
              <span className="flex items-center gap-1"><Mail className="w-3.5 h-3.5" /> {mockApplicant.email}</span>
              <span className="flex items-center gap-1"><Phone className="w-3.5 h-3.5" /> {mockApplicant.phone}</span>
              <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {mockApplicant.address}</span>
            </div>
          </div>
        </div>
      </motion.div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-2">Objective</h3>
        <p className="text-sm text-muted-foreground">{mockApplicant.objective}</p>
      </div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-3">Skills</h3>
        <div className="flex flex-wrap gap-2">
          {mockApplicant.skills.map(s => <span key={s} className="px-3 py-1.5 text-xs font-medium rounded-lg bg-primary/10 text-primary">{s}</span>)}
        </div>
      </div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-3 flex items-center gap-2"><Briefcase className="w-4 h-4 text-primary" /> Experience</h3>
        {mockApplicant.experience.map((e, i) => (
          <div key={i} className="border-l-2 border-primary/30 pl-4">
            <h4 className="font-medium text-sm">{e.title}</h4>
            <p className="text-xs text-muted-foreground">{e.company} · {e.period}</p>
          </div>
        ))}
      </div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-3 flex items-center gap-2"><GraduationCap className="w-4 h-4 text-primary" /> Education</h3>
        {mockApplicant.education.map((e, i) => (
          <div key={i} className="border-l-2 border-primary/30 pl-4">
            <h4 className="font-medium text-sm">{e.degree}</h4>
            <p className="text-xs text-muted-foreground">{e.school} · {e.year}</p>
          </div>
        ))}
      </div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-3 flex items-center gap-2"><Award className="w-4 h-4 text-primary" /> Certificates</h3>
        {mockApplicant.certificates.map((c, i) => <p key={i} className="text-sm text-muted-foreground">• {c}</p>)}
      </div>
    </div>
  );
}
