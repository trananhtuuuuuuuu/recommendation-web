import { useParams, useNavigate } from "react-router-dom";
import { ArrowLeft, Mail, User, Shield } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";

const jobApplicantsData: Record<number, { jobTitle: string; applicants: { id: number; fullName: string; email: string; status: string }[] }> = {
  1: {
    jobTitle: "Senior Frontend Developer",
    applicants: [
      { id: 1, fullName: "Alice Nguyen", email: "alice.n@email.com", status: "Under Review" },
      { id: 2, fullName: "Brian Lee", email: "brian.lee@email.com", status: "Interview Scheduled" },
      { id: 3, fullName: "Clara Zhang", email: "clara.z@email.com", status: "Shortlisted" },
    ],
  },
  2: {
    jobTitle: "Data Privacy Engineer",
    applicants: [
      { id: 4, fullName: "David Kim", email: "d.kim@email.com", status: "Applied" },
      { id: 5, fullName: "Eva Martinez", email: "eva.m@email.com", status: "Under Review" },
    ],
  },
  3: {
    jobTitle: "Backend Developer",
    applicants: [
      { id: 6, fullName: "Frank Patel", email: "frank.p@email.com", status: "Rejected" },
      { id: 7, fullName: "Grace Wang", email: "grace.w@email.com", status: "Interview Scheduled" },
      { id: 8, fullName: "Henry Davis", email: "henry.d@email.com", status: "Applied" },
      { id: 9, fullName: "Iris Johnson", email: "iris.j@email.com", status: "Shortlisted" },
    ],
  },
  4: {
    jobTitle: "UI/UX Designer",
    applicants: [
      { id: 10, fullName: "Jack Chen", email: "jack.c@email.com", status: "Applied" },
    ],
  },
  5: {
    jobTitle: "Security Analyst",
    applicants: [
      { id: 11, fullName: "Karen Smith", email: "karen.s@email.com", status: "Under Review" },
      { id: 12, fullName: "Leo Brown", email: "leo.b@email.com", status: "Interview Scheduled" },
    ],
  },
};

const statusColors: Record<string, string> = {
  Applied: "bg-muted text-muted-foreground",
  "Under Review": "bg-warning/10 text-warning",
  Shortlisted: "bg-primary/10 text-primary",
  "Interview Scheduled": "bg-success/10 text-success",
  Rejected: "bg-destructive/10 text-destructive",
};

export default function JobApplicants() {
  const { jobId } = useParams();
  const navigate = useNavigate();
  const data = jobApplicantsData[Number(jobId)];

  if (!data) {
    return (
      <div className="text-center py-20">
        <p className="text-muted-foreground">Job not found.</p>
        <Button variant="outline" className="mt-4" onClick={() => navigate("/jobs")}>
          Back to Jobs
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={() => navigate("/jobs")}>
          <ArrowLeft className="w-4 h-4" />
        </Button>
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Applicants</h1>
          <p className="text-sm text-muted-foreground mt-0.5">
            {data.applicants.length} applicant{data.applicants.length !== 1 ? "s" : ""} for <span className="text-primary font-medium">{data.jobTitle}</span>
          </p>
        </div>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left">
              <th className="py-3 px-4 font-medium text-muted-foreground">#</th>
              <th className="py-3 px-4 font-medium text-muted-foreground">Full Name</th>
              <th className="py-3 px-4 font-medium text-muted-foreground">Email</th>
              <th className="py-3 px-4 font-medium text-muted-foreground">Status</th>
              <th className="py-3 px-4 font-medium text-muted-foreground">Actions</th>
            </tr>
          </thead>
          <tbody>
            {data.applicants.map((applicant, i) => (
              <motion.tr
                key={applicant.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.04 }}
                className="border-b border-border/50 hover:bg-secondary/50 transition-colors"
              >
                <td className="py-3 px-4 text-muted-foreground">{i + 1}</td>
                <td className="py-3 px-4">
                  <div className="flex items-center gap-2">
                    <div className="w-7 h-7 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                      <User className="w-3.5 h-3.5 text-primary" />
                    </div>
                    <span className="font-medium text-foreground">{applicant.fullName}</span>
                  </div>
                </td>
                <td className="py-3 px-4">
                  <div className="flex items-center gap-1.5 text-muted-foreground">
                    <Mail className="w-3 h-3" />
                    {applicant.email}
                  </div>
                </td>
                <td className="py-3 px-4">
                  <Badge className={`text-[10px] ${statusColors[applicant.status] || "bg-muted text-muted-foreground"}`}>
                    {applicant.status}
                  </Badge>
                </td>
                <td className="py-3 px-4">
                  <Button variant="outline" size="sm" className="gap-1 text-xs">
                    <Shield className="w-3 h-3" /> View Profile
                  </Button>
                </td>
              </motion.tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
