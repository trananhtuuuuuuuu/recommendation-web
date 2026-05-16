import { Shield, Lock, Eye, Users, Briefcase, ArrowRight, CheckCircle } from "lucide-react";
import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";

const stats = [
  { label: "Jobs Posted", value: "2,450+", icon: Briefcase },
  { label: "Privacy Protected", value: "99.9%", icon: Shield },
  { label: "Active Users", value: "18K+", icon: Users },
  { label: "Data Encrypted", value: "100%", icon: Lock },
];

const features = [
  {
    icon: Shield,
    title: "Privacy-First Matching",
    desc: "Your profile data is encrypted and only shared with explicit consent.",
  },
  {
    icon: Eye,
    title: "Anonymous Browsing",
    desc: "Browse job listings without exposing your identity to recruiters.",
  },
  {
    icon: Lock,
    title: "Encrypted CVs",
    desc: "Your CV data is encrypted at rest and in transit using AES-256.",
  },
  {
    icon: CheckCircle,
    title: "Consent Management",
    desc: "Full control over which recruiters can view your information.",
  },
];

const container = {
  hidden: {},
  show: { transition: { staggerChildren: 0.1 } },
};

const item = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0 },
};

export default function Index() {
  return (
    <div className="space-y-16">
      {/* Hero */}
      <section className="relative overflow-hidden rounded-2xl p-8 lg:p-16" style={{ background: "var(--gradient-hero)" }}>
        <div className="absolute inset-0 opacity-20">
          <div className="absolute top-10 right-10 w-64 h-64 rounded-full bg-primary/30 blur-[100px]" />
          <div className="absolute bottom-10 left-10 w-48 h-48 rounded-full bg-accent/20 blur-[80px]" />
        </div>
        <div className="relative z-10 max-w-2xl">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/15 border border-primary/25 mb-6">
              <Shield className="w-3.5 h-3.5 text-primary" />
              <span className="text-xs font-medium text-primary">Privacy-Preserving Platform</span>
            </div>
            <h1 className="font-display text-3xl lg:text-5xl font-bold text-primary-foreground leading-tight mb-4">
              Your Career, Your{" "}
              <span className="text-gradient">Privacy</span>
            </h1>
            <p className="text-primary-foreground/70 text-base lg:text-lg mb-8 max-w-lg">
              Find your dream job without compromising your personal data. Our privacy-preserving 
              recommendation engine connects you with opportunities securely.
            </p>
            <div className="flex flex-wrap gap-3">
              <Link to="/jobs">
                <Button className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2">
                  Browse Jobs <ArrowRight className="w-4 h-4" />
                </Button>
              </Link>
              <Link to="/profiles">
                <Button variant="outline" className="border-primary-foreground/20 text-primary-foreground hover:bg-primary-foreground/10">
                  Create Profile
                </Button>
              </Link>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Stats */}
      <motion.section
        variants={container}
        initial="hidden"
        animate="show"
        className="grid grid-cols-2 lg:grid-cols-4 gap-4"
      >
        {stats.map(({ label, value, icon: Icon }) => (
          <motion.div
            key={label}
            variants={item}
            className="glass-card rounded-xl p-5 text-center"
          >
            <Icon className="w-5 h-5 text-primary mx-auto mb-2" />
            <p className="font-display text-2xl font-bold text-foreground">{value}</p>
            <p className="text-xs text-muted-foreground mt-1">{label}</p>
          </motion.div>
        ))}
      </motion.section>

      {/* Features */}
      <section>
        <h2 className="font-display text-2xl font-bold text-foreground mb-6">
          Why PrivacyJobs?
        </h2>
        <motion.div
          variants={container}
          initial="hidden"
          whileInView="show"
          viewport={{ once: true }}
          className="grid md:grid-cols-2 gap-4"
        >
          {features.map(({ icon: Icon, title, desc }) => (
            <motion.div
              key={title}
              variants={item}
              className="group glass-card rounded-xl p-6 hover:shield-glow transition-shadow duration-300"
            >
              <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center mb-4 group-hover:bg-primary/20 transition-colors">
                <Icon className="w-5 h-5 text-primary" />
              </div>
              <h3 className="font-display font-semibold text-foreground mb-2">{title}</h3>
              <p className="text-sm text-muted-foreground">{desc}</p>
            </motion.div>
          ))}
        </motion.div>
      </section>
    </div>
  );
}
