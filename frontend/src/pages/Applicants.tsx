import { User, Shield, MapPin, Star, Eye, Mail } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";

const applicants = [
  {
    id: 1, name: "Anonymous #A2847", status: "Active", privacy: "Full",
    skills: ["React", "TypeScript", "Node.js"], location: "Region: West Coast",
    matchScore: 95, applications: 4,
  },
  {
    id: 2, name: "Anonymous #B1923", status: "Active", privacy: "Partial",
    skills: ["Python", "ML", "Cryptography"], location: "Region: East Coast",
    matchScore: 88, applications: 7,
  },
  {
    id: 3, name: "Anonymous #C4521", status: "Inactive", privacy: "Full",
    skills: ["Java", "Spring Boot", "AWS"], location: "Region: Midwest",
    matchScore: 76, applications: 2,
  },
  {
    id: 4, name: "Anonymous #D7834", status: "Active", privacy: "Full",
    skills: ["Figma", "CSS", "User Research"], location: "Region: Remote",
    matchScore: 92, applications: 5,
  },
  {
    id: 5, name: "Anonymous #E3156", status: "Active", privacy: "Minimal",
    skills: ["Go", "Kubernetes", "Terraform"], location: "Region: South",
    matchScore: 83, applications: 3,
  },
];

const statusColors: Record<string, string> = {
  Active: "bg-success/10 text-success",
  Inactive: "bg-muted text-muted-foreground",
};

export default function Applicants() {
  const navigate = useNavigate();
  return (
    <div className="space-y-6">
      <div>
        <h1 className="font-display text-2xl font-bold text-foreground">Applicants</h1>
        <p className="text-sm text-muted-foreground mt-1">Privacy-protected candidate profiles</p>
      </div>

      <div className="space-y-3">
        {applicants.map((a, i) => (
          <motion.div
            key={a.id}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.05 }}
            className="glass-card rounded-xl p-5"
          >
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div className="flex items-center gap-4">
                <div className="w-11 h-11 rounded-full bg-primary/10 flex items-center justify-center">
                  <User className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <h3 className="font-display font-semibold text-foreground text-sm">{a.name}</h3>
                    <Badge className={`text-[10px] ${statusColors[a.status]}`}>{a.status}</Badge>
                    <Badge className="text-[10px] bg-primary/10 text-primary">
                      <Shield className="w-2.5 h-2.5 mr-0.5" /> {a.privacy}
                    </Badge>
                  </div>
                  <div className="flex items-center gap-3 mt-1 text-xs text-muted-foreground">
                    <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {a.location}</span>
                    <span className="flex items-center gap-1"><Star className="w-3 h-3 text-warning" /> {a.matchScore}% match</span>
                  </div>
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {a.skills.map(s => (
                      <span key={s} className="px-2 py-0.5 text-[10px] rounded-md bg-secondary text-secondary-foreground font-medium">{s}</span>
                    ))}
                  </div>
                </div>
              </div>
              <div className="flex gap-2">
                <Button variant="outline" size="sm" className="gap-1 text-xs" onClick={() => navigate(`/applicants/${a.id}`)}><Eye className="w-3 h-3" /> Profile</Button>
                <Button size="sm" className="bg-primary text-primary-foreground hover:bg-primary/90 gap-1 text-xs"><Mail className="w-3 h-3" /> Contact</Button>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
