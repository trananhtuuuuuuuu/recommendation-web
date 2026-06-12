import {
  ArrowRight,
  Briefcase,
  Building2,
  CheckCircle,
  Clock,
  Eye,
  FileCheck2,
  Lock,
  MapPin,
  Search,
  Shield,
  UserRoundCheck,
  Users,
} from "lucide-react";
import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useEffect, useMemo, useState } from "react";
import { fetchHome, fetchJobs, getJobId, getJobTitle, type HomeSummary, type Job } from "@/lib/jobsApi";
import { Badge } from "@/components/ui/badge";
import { useAuth } from "@/contexts/AuthContext";
import PrivacyMatchVisual from "@/components/PrivacyMatchVisual";

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

const journey = [
  {
    icon: Search,
    title: "Explore openly",
    desc: "Search roles and company details before deciding whether to create an account.",
  },
  {
    icon: UserRoundCheck,
    title: "Build your profile",
    desc: "Add career details and a reusable CV from one protected applicant workspace.",
  },
  {
    icon: FileCheck2,
    title: "Apply with context",
    desc: "Review each role, answer recruiter questions, and track saved and submitted jobs.",
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
  const { isAuthenticated, role } = useAuth();
  const [homeData, setHomeData] = useState<HomeSummary | null>(null);
  const [latestJobs, setLatestJobs] = useState<Job[]>([]);

  useEffect(() => {
    let active = true;
    Promise.allSettled([fetchHome(), fetchJobs()]).then(([homeResult, jobsResult]) => {
      if (!active) return;
      if (homeResult.status === "fulfilled") setHomeData(homeResult.value);
      if (jobsResult.status === "fulfilled" && Array.isArray(jobsResult.value)) {
        setLatestJobs(jobsResult.value.slice(0, 3));
      }
    });
    return () => { active = false; };
  }, []);

  const stats = useMemo(() => [
    { label: "Jobs Posted", value: String(homeData?.jobsPosted ?? 0), icon: Briefcase },
    { label: "Recruiters", value: String(homeData?.recruiters ?? 0), icon: Shield },
    { label: "Active Applicants", value: String(homeData?.activeApplicants ?? 0), icon: Users },
    { label: "Data Encrypted", value: "100%", icon: Lock },
  ], [homeData]);

  const primaryAction = role === "RECRUITER"
    ? { to: "/recruiters/jobs", label: "Manage job posts" }
    : role === "ADMIN"
      ? { to: "/admin/applicants", label: "Open admin workspace" }
      : role === "APPLICANT"
        ? { to: "/profiles", label: "Complete your profile" }
        : { to: "/applicants/registration", label: "Create applicant account" };

  return (
    <div className="mx-auto max-w-7xl space-y-16">
      {/* Hero */}
      <section
        className="relative overflow-hidden rounded-2xl p-8 shadow-[0_34px_90px_-58px_hsl(var(--primary)/0.8)] lg:p-14"
        style={{ background: "var(--gradient-hero)" }}
      >
        <div className="absolute inset-0 opacity-20">
          <div className="absolute top-10 right-10 w-64 h-64 rounded-full bg-primary/30 blur-[100px]" />
          <div className="absolute bottom-10 left-10 w-48 h-48 rounded-full bg-accent/20 blur-[80px]" />
        </div>
        <div className="absolute inset-0 bg-[linear-gradient(115deg,transparent_0%,rgba(255,255,255,0.04)_48%,transparent_70%)]" />
        <div className="relative z-10 grid items-center gap-10 lg:grid-cols-[minmax(0,1fr)_390px] lg:gap-14">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="max-w-2xl"
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
              <Button asChild className="gap-2 bg-primary text-primary-foreground hover:bg-primary/90">
                <Link to="/jobs">
                  Browse Jobs <ArrowRight className="w-4 h-4" />
                </Link>
              </Button>
              <Button
                asChild
                variant="outline"
                className="border-white/30 bg-transparent text-white hover:border-white/50 hover:bg-white/10 hover:text-white"
              >
                <Link to="/profiles">
                  {isAuthenticated ? "Open Profile" : "Create Profile"}
                </Link>
              </Button>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, scale: 0.94, x: 24 }}
            animate={{ opacity: 1, scale: 1, x: 0 }}
            transition={{ duration: 0.75, delay: 0.15 }}
            className="hidden lg:block"
          >
            <PrivacyMatchVisual />
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
            className="glass-card interactive-surface rounded-xl p-5 text-center"
          >
            <Icon className="w-5 h-5 text-primary mx-auto mb-2" />
            <p className="font-display text-2xl font-bold text-foreground">{value}</p>
            <p className="text-xs text-muted-foreground mt-1">{label}</p>
          </motion.div>
        ))}
      </motion.section>

      <section className="space-y-6">
        <div className="flex flex-col justify-between gap-3 sm:flex-row sm:items-end">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">Live opportunities</p>
            <h2 className="mt-2 font-display text-2xl font-bold text-foreground">Available roles</h2>
            <p className="mt-1 text-sm text-muted-foreground">A quick view of live jobs already provided by the backend.</p>
          </div>
          <Button asChild variant="outline" className="w-fit gap-2">
            <Link to="/jobs">View all jobs <ArrowRight className="h-4 w-4" /></Link>
          </Button>
        </div>

        {latestJobs.length > 0 ? (
          <div className="grid gap-4 md:grid-cols-3">
            {latestJobs.map((job) => {
              const id = getJobId(job);
              return (
                <Link
                  key={id}
                  to={`/jobs/${id}`}
                  className="glass-card interactive-surface group rounded-xl p-5"
                >
                  <div className="flex items-start justify-between gap-3">
                    <span className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                      <Briefcase className="h-5 w-5" />
                    </span>
                    {job.jobType ? <Badge variant="outline" className="text-[10px]">{job.jobType}</Badge> : null}
                  </div>
                  <h3 className="mt-4 font-display font-semibold text-foreground transition-colors group-hover:text-primary">
                    {getJobTitle(job)}
                  </h3>
                  <div className="mt-3 space-y-2 text-xs text-muted-foreground">
                    {job.companyName ? <p className="flex items-center gap-2"><Building2 className="h-3.5 w-3.5" /> {job.companyName}</p> : null}
                    {job.location ? <p className="flex items-center gap-2"><MapPin className="h-3.5 w-3.5" /> {job.location}</p> : null}
                    {job.postedDate ? <p className="flex items-center gap-2"><Clock className="h-3.5 w-3.5" /> Posted {job.postedDate}</p> : null}
                  </div>
                  <div className="mt-5 flex items-center gap-1 text-xs font-medium text-primary">
                    Review role <ArrowRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-1" />
                  </div>
                </Link>
              );
            })}
          </div>
        ) : (
          <div className="rounded-xl border border-dashed bg-card/50 p-8 text-center">
            <Briefcase className="mx-auto h-7 w-7 text-muted-foreground" />
            <p className="mt-3 text-sm text-muted-foreground">Live jobs will appear here when the jobs API has listings.</p>
          </div>
        )}
      </section>

      {/* Features */}
      <section>
        <div className="mb-6 flex items-end gap-4">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">Built for trust</p>
            <h2 className="mt-2 font-display text-2xl font-bold text-foreground">Why PrivacyJobs?</h2>
          </div>
          <div className="mb-2 hidden h-px flex-1 bg-gradient-to-r from-primary/40 to-transparent sm:block" />
        </div>
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
              className="group glass-card interactive-surface rounded-xl p-6"
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

      <section className="glass-card rounded-2xl p-6 sm:p-8">
        <div className="max-w-2xl">
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">Applicant journey</p>
          <h2 className="mt-2 font-display text-2xl font-bold text-foreground">A clear path from discovery to application</h2>
          <p className="mt-2 text-sm text-muted-foreground">Each step corresponds to an existing page and workflow in the application.</p>
        </div>
        <div className="mt-8 grid gap-4 md:grid-cols-3">
          {journey.map(({ icon: Icon, title, desc }, index) => (
            <div key={title} className="interactive-surface relative rounded-xl border border-border/60 bg-secondary/55 p-5">
              <span className="absolute right-4 top-3 font-display text-4xl font-bold text-primary/10">0{index + 1}</span>
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                <Icon className="h-5 w-5" />
              </div>
              <h3 className="mt-4 font-display font-semibold text-foreground">{title}</h3>
              <p className="mt-2 text-sm leading-6 text-muted-foreground">{desc}</p>
            </div>
          ))}
        </div>
      </section>

      <section
        className="relative overflow-hidden rounded-2xl p-7 sm:p-10"
        style={{ background: "var(--gradient-hero)" }}
      >
        <div className="absolute right-0 top-0 h-56 w-56 rounded-full bg-primary/20 blur-3xl" />
        <div className="relative flex flex-col justify-between gap-6 md:flex-row md:items-center">
          <div className="max-w-2xl">
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">
              {isAuthenticated ? "Your workspace is ready" : "Start with the role that fits"}
            </p>
            <h2 className="mt-2 font-display text-2xl font-bold text-primary-foreground sm:text-3xl">
              Turn the next useful action into progress.
            </h2>
            <p className="mt-2 text-sm leading-6 text-primary-foreground/70">
              Applicants can build a reusable profile, while recruiters can create a company account and publish structured job posts.
            </p>
          </div>
          <div className="flex flex-wrap gap-3">
            <Button asChild className="gap-2">
              <Link to={primaryAction.to}>{primaryAction.label} <ArrowRight className="h-4 w-4" /></Link>
            </Button>
            {!isAuthenticated ? (
              <Button asChild variant="outline" className="border-primary-foreground/20 text-primary-foreground hover:bg-primary-foreground/10">
                <Link to="/recruiters/registration">Register as recruiter</Link>
              </Button>
            ) : null}
          </div>
        </div>
      </section>
    </div>
  );
}
