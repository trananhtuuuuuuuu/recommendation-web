import { Bell, Briefcase, Shield, MessageSquare, CheckCircle, User, Clock } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { motion } from "framer-motion";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { useState } from "react";

const initialNotifications = [
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
  const [notifications, setNotifications] = useState(initialNotifications);
  const [filter, setFilter] = useState<"all" | "unread">("all");
  const unreadCount = notifications.filter((notification) => !notification.read).length;
  const visibleNotifications = filter === "unread"
    ? notifications.filter((notification) => !notification.read)
    : notifications;

  const markAllRead = () => {
    setNotifications((current) => current.map((notification) => ({ ...notification, read: true })));
  };

  const toggleRead = (id: number) => {
    setNotifications((current) => current.map((notification) =>
      notification.id === id ? { ...notification, read: !notification.read } : notification
    ));
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
        <div>
          <h1 className="font-display text-2xl font-bold text-foreground">Notifications</h1>
          <p className="text-sm text-muted-foreground mt-1">Stay informed about your activity</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Badge className="bg-primary/10 text-primary text-xs">{unreadCount} new</Badge>
          <Button variant={filter === "all" ? "secondary" : "ghost"} size="sm" onClick={() => setFilter("all")}>All</Button>
          <Button variant={filter === "unread" ? "secondary" : "ghost"} size="sm" onClick={() => setFilter("unread")}>Unread</Button>
          <Button variant="outline" size="sm" onClick={markAllRead} disabled={unreadCount === 0}>Mark all read</Button>
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-3">
        <NotificationSummary icon={Bell} label="All activity" value={notifications.length} />
        <NotificationSummary icon={Clock} label="Needs attention" value={unreadCount} />
        <NotificationSummary icon={Shield} label="Privacy updates" value={notifications.filter((notification) => notification.type === "privacy").length} />
      </div>

      <div className="space-y-2">
        {visibleNotifications.map((n, i) => {
          const Icon = n.icon;
          return (
            <motion.button
              type="button"
              key={n.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.04 }}
              onClick={() => toggleRead(n.id)}
              className={`glass-card flex w-full items-start gap-4 rounded-xl p-4 text-left transition-all hover:shield-glow ${
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
            </motion.button>
          );
        })}
        {visibleNotifications.length === 0 ? (
          <div className="rounded-xl border border-dashed bg-card p-10 text-center">
            <CheckCircle className="mx-auto h-7 w-7 text-success" />
            <h2 className="mt-3 font-display font-semibold text-foreground">You are all caught up</h2>
            <p className="mt-1 text-sm text-muted-foreground">There are no unread notifications in this placeholder feed.</p>
          </div>
        ) : null}
      </div>
    </div>
  );
}

function NotificationSummary({
  icon: Icon,
  label,
  value,
}: {
  icon: LucideIcon;
  label: string;
  value: number;
}) {
  return (
    <div className="flex items-center gap-3 rounded-xl border bg-card p-4">
      <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
        <Icon className="h-4 w-4" />
      </span>
      <div>
        <p className="font-display text-xl font-bold text-foreground">{value}</p>
        <p className="text-xs text-muted-foreground">{label}</p>
      </div>
    </div>
  );
}
