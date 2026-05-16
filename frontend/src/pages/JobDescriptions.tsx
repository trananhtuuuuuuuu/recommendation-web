import { Plus, Edit, Trash2, Eye, Users, Calendar, CheckCircle, Clock, XCircle } from "lucide-react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

const jds = [
  {
    id: 1, jobName: "Senior Frontend Developer", status: "Active",
    applicants: 24, startDate: "2024-01-15", endDate: "2024-03-15",
    recruiter: "TechCorp",
    about: "Join our team to build privacy-preserving web applications.",
  },
  {
    id: 2, jobName: "Data Privacy Engineer", status: "Active",
    applicants: 18, startDate: "2024-02-01", endDate: "2024-04-01",
    recruiter: "SecureAI",
    about: "Design ML systems with built-in differential privacy.",
  },
  {
    id: 3, jobName: "DevOps Engineer", status: "Closed",
    applicants: 32, startDate: "2023-11-01", endDate: "2024-01-01",
    recruiter: "CloudShield",
    about: "Manage secure CI/CD pipelines and infrastructure.",
  },
  {
    id: 4, jobName: "Product Manager", status: "Draft",
    applicants: 0, startDate: "2024-03-01", endDate: "2024-05-01",
    recruiter: "TechCorp",
    about: "Lead privacy-focused product development initiatives.",
  },
];

const statusConfig: Record<string, { icon: React.ElementType; className: string }> = {
  Active: { icon: CheckCircle, className: "bg-success/10 text-success" },
  Closed: { icon: XCircle, className: "bg-destructive/10 text-destructive" },
  Draft: { icon: Clock, className: "bg-warning/10 text-warning" },
};

export default function JobDescriptions() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Job Descriptions</h1>
          <p className="text-sm text-muted-foreground mt-1">Manage your job postings</p>
        </div>
        <Button className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2">
          <Plus className="w-4 h-4" /> New JD
        </Button>
      </div>

      <div className="grid gap-4">
        {jds.map((jd, i) => {
          const status = statusConfig[jd.status];
          const StatusIcon = status.icon;
          return (
            <motion.div
              key={jd.id}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
              className="glass-card rounded-xl p-5"
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="font-display font-semibold text-foreground">{jd.jobName}</h3>
                    <Badge className={`text-[10px] ${status.className}`}>
                      <StatusIcon className="w-3 h-3 mr-1" /> {jd.status}
                    </Badge>
                  </div>
                  <p className="text-sm text-muted-foreground mb-3">{jd.about}</p>
                  <div className="flex flex-wrap gap-4 text-xs text-muted-foreground">
                    <span className="flex items-center gap-1"><Users className="w-3 h-3" /> {jd.applicants} applicants</span>
                    <span className="flex items-center gap-1"><Calendar className="w-3 h-3" /> {jd.startDate} — {jd.endDate}</span>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <Button variant="outline" size="sm" className="gap-1"><Eye className="w-3 h-3" /> View</Button>
                  <Button variant="outline" size="sm" className="gap-1"><Edit className="w-3 h-3" /> Edit</Button>
                  <Button variant="outline" size="sm" className="text-destructive hover:bg-destructive/10 gap-1"><Trash2 className="w-3 h-3" /></Button>
                </div>
              </div>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
