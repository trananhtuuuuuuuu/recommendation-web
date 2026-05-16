import { useParams, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Building2, Mail, Phone, MapPin, ArrowLeft, Briefcase } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

const mock = {
  fullName: "Sarah Johnson",
  companyName: "TechCorp Inc.",
  position: "Senior HR Manager",
  email: "sarah@techcorp.com",
  phone: "+1 555-987-6543",
  address: "San Francisco, CA",
  jobsPosted: 12,
  description: "Hiring privacy-first engineers for fast-growing teams.",
};

export default function RecruiterDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <Button variant="ghost" size="sm" onClick={() => navigate(-1)} className="gap-1">
        <ArrowLeft className="w-4 h-4" /> Back
      </Button>

      <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} className="glass-card rounded-xl p-6">
        <div className="flex items-center gap-5">
          <div className="w-16 h-16 rounded-full bg-primary/15 flex items-center justify-center"><Building2 className="w-7 h-7 text-primary" /></div>
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-1">
              <h2 className="font-display text-xl font-bold text-foreground">{mock.fullName}</h2>
              <Badge className="bg-primary/10 text-primary text-[10px]">ID: {id}</Badge>
            </div>
            <p className="text-sm text-muted-foreground mb-2">{mock.position} at <span className="font-medium text-foreground">{mock.companyName}</span></p>
            <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
              <span className="flex items-center gap-1"><Mail className="w-3.5 h-3.5" /> {mock.email}</span>
              <span className="flex items-center gap-1"><Phone className="w-3.5 h-3.5" /> {mock.phone}</span>
              <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" /> {mock.address}</span>
            </div>
          </div>
        </div>
      </motion.div>

      <div className="glass-card rounded-xl p-6">
        <h3 className="font-display font-semibold text-foreground mb-2">About</h3>
        <p className="text-sm text-muted-foreground">{mock.description}</p>
      </div>

      <div className="glass-card rounded-xl p-6 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Briefcase className="w-5 h-5 text-primary" />
          <div>
            <p className="font-display font-semibold text-foreground">{mock.jobsPosted} Jobs Posted</p>
            <p className="text-xs text-muted-foreground">Active and historical postings</p>
          </div>
        </div>
        <Button size="sm" variant="outline" onClick={() => navigate("/recruiters/jobs")}>View Jobs</Button>
      </div>
    </div>
  );
}
