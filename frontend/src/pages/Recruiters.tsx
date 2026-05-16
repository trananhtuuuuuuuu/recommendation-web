import { Building2, MapPin, Briefcase, Shield, ExternalLink } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";

const recruiters = [
  {
    id: 1, company: "TechCorp", industry: "Technology", location: "San Francisco, CA",
    openJobs: 8, privacyScore: 98, verified: true,
    description: "Leading tech company focused on privacy-preserving AI solutions.",
  },
  {
    id: 2, company: "SecureAI", industry: "Artificial Intelligence", location: "New York, NY",
    openJobs: 5, privacyScore: 100, verified: true,
    description: "Building the future of AI with differential privacy at its core.",
  },
  {
    id: 3, company: "CloudShield", industry: "Cloud Security", location: "Austin, TX",
    openJobs: 12, privacyScore: 95, verified: true,
    description: "Enterprise cloud security and compliance solutions provider.",
  },
  {
    id: 4, company: "DesignFirst", industry: "Design", location: "Remote",
    openJobs: 3, privacyScore: 88, verified: false,
    description: "Creative design studio specializing in privacy-focused UX.",
  },
  {
    id: 5, company: "CyberGuard", industry: "Cybersecurity", location: "Washington, DC",
    openJobs: 6, privacyScore: 97, verified: true,
    description: "Government-grade cybersecurity solutions for enterprises.",
  },
];

export default function Recruiters() {
  const navigate = useNavigate();
  return (
    <div className="space-y-6">
      <div>
        <h1 className="font-display text-2xl font-bold text-foreground">Recruiters</h1>
        <p className="text-sm text-muted-foreground mt-1">Privacy-verified companies hiring now</p>
      </div>

      <div className="grid md:grid-cols-2 gap-4">
        {recruiters.map((r, i) => (
          <motion.div
            key={r.id}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.05 }}
            className="glass-card rounded-xl p-5 hover:shield-glow transition-shadow group"
          >
            <div className="flex items-start justify-between mb-3">
              <div className="flex items-center gap-3">
                <div className="w-11 h-11 rounded-lg bg-primary/10 flex items-center justify-center">
                  <Building2 className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <h3 className="font-display font-semibold text-foreground">{r.company}</h3>
                    {r.verified && <Shield className="w-3.5 h-3.5 text-primary" />}
                  </div>
                  <p className="text-xs text-muted-foreground">{r.industry}</p>
                </div>
              </div>
              <Badge className="bg-primary/10 text-primary text-[10px]">{r.privacyScore}% Privacy</Badge>
            </div>
            <p className="text-sm text-muted-foreground mb-3">{r.description}</p>
            <div className="flex items-center justify-between">
              <div className="flex gap-4 text-xs text-muted-foreground">
                <span className="flex items-center gap-1"><MapPin className="w-3 h-3" /> {r.location}</span>
                <span className="flex items-center gap-1"><Briefcase className="w-3 h-3" /> {r.openJobs} open</span>
              </div>
              <Button variant="outline" size="sm" className="gap-1 text-xs" onClick={() => navigate(`/recruiters/${r.id}`)}>
                View <ExternalLink className="w-3 h-3" />
              </Button>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
