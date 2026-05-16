import { Bell, Briefcase, Shield, MessageSquare, CheckCircle, User, Clock } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";

const notifications = [
  {
    id: 1, type: "application", icon: Briefcase, time: "5 min ago", read: false,
    title: "Application Received",
    desc: "Your application for Senior Frontend Developer at TechCorp has been received.",
  },
  {
    id: 2, type: "privacy", icon: Shield, time: "1 hour ago", read: false,
    title: "Privacy Alert",
    desc: "A recruiter requested access to your full profile. Review and approve in settings.",
  },
  {
    id: 3, type: "message", icon: MessageSquare, time: "3 hours ago", read: true,
    title: "New Message",
    desc: "You have a new encrypted message from SecureAI's hiring team.",
  },
  {
    id: 4, type: "status", icon: CheckCircle, time: "1 day ago", read: true,
    title: "Application Update",
    desc: "Your application for Data Privacy Engineer has moved to interview stage.",
  },
  {
    id: 5, type: "profile", icon: User, time: "2 days ago", read: true,
    title: "Profile View",
    desc: "3 recruiters viewed your anonymized profile this week.",
  },
  {
    id: 6, type: "system", icon: Clock, time: "3 days ago", read: true,
    title: "CV Encryption Updated",
    desc: "Your CV encryption keys have been rotated successfully.",
  },
];

const typeColors: Record<string, string> = {
  application: "bg-trust/10 text-trust",
  privacy: "bg-warning/10 text-warning",
  message: "bg-primary/10 text-primary",
  status: "bg-success/10 text-success",
  profile: "bg-accent/10 text-accent",
  system: "bg-muted text-muted-foreground",
};

export default function Notifications() {
  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Notifications</h1>
          <p className="text-sm text-muted-foreground mt-1">Stay informed about your activity</p>
        </div>
        <Badge className="bg-primary/10 text-primary text-xs">
          {notifications.filter(n => !n.read).length} new
        </Badge>
      </div>

      <div className="space-y-2">
        {notifications.map((n, i) => {
          const Icon = n.icon;
          return (
            <motion.div
              key={n.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.04 }}
              className={`glass-card rounded-xl p-4 flex items-start gap-4 transition-all cursor-pointer hover:shield-glow ${
                !n.read ? "border-l-2 border-l-primary" : ""
              }`}
            >
              <div className={`w-9 h-9 rounded-lg flex items-center justify-center shrink-0 ${typeColors[n.type]}`}>
                <Icon className="w-4 h-4" />
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <h3 className={`text-sm font-medium ${!n.read ? "text-foreground" : "text-muted-foreground"}`}>{n.title}</h3>
                  <span className="text-[10px] text-muted-foreground shrink-0 ml-2">{n.time}</span>
                </div>
                <p className="text-xs text-muted-foreground mt-0.5">{n.desc}</p>
              </div>
              {!n.read && <div className="w-2 h-2 rounded-full bg-primary shrink-0 mt-2" />}
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
