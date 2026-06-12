import type { LucideIcon } from "lucide-react";
import {
  Facebook,
  GraduationCap,
  Instagram,
  Linkedin,
  Mail,
  MapPin,
  MessageCircle,
  Shield,
  Youtube,
} from "lucide-react";
import { NavLink } from "react-router-dom";

const socialLinks: { label: string; href: string; icon: LucideIcon }[] = [
  { label: "Facebook", href: "https://www.facebook.com/us.vnuhcm", icon: Facebook },
  { label: "Instagram", href: "https://www.instagram.com/hcmus.vnuhcm", icon: Instagram },
  { label: "Zalo", href: "https://zalo.me/02862884499", icon: MessageCircle },
  { label: "LinkedIn", href: "https://www.linkedin.com/school/university-of-science-vnuhcm", icon: Linkedin },
  { label: "YouTube", href: "https://www.youtube.com/@HCMUSVNUHCM", icon: Youtube },
];

const campuses = [
  {
    title: "Campus 1",
    address: "227 Nguyen Van Cu Street, Cho Quan Ward, Ho Chi Minh City, Vietnam",
  },
  {
    title: "Campus 2",
    address: "Vietnam National University Ho Chi Minh City Urban Area, Dong Hoa Ward, Ho Chi Minh City, Vietnam",
  },
];

export default function SiteFooter() {
  return (
    <footer className="border-t border-sidebar-border bg-sidebar text-sidebar-foreground">
      <div className="mx-auto max-w-[1600px] px-4 py-10 lg:px-8 lg:py-12">
        <div className="grid gap-10 md:grid-cols-2 xl:grid-cols-[1.15fr_0.85fr_0.8fr_0.75fr]">
          <section>
            <div className="flex items-center gap-3">
              <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-sidebar-primary/15 text-sidebar-primary ring-1 ring-sidebar-primary/20">
                <Shield className="h-5 w-5" />
              </span>
              <div>
                <p className="font-display text-base font-bold text-white">PrivacyJobs</p>
                <p className="text-xs text-sidebar-foreground/70">Privacy-preserving recruitment platform</p>
              </div>
            </div>
            <p className="mt-5 max-w-md text-sm leading-6 text-sidebar-foreground/75">
              A graduation project developed at the University of Science, Vietnam National University Ho Chi Minh City,
              connecting applicants and recruiters through secure, transparent career workflows.
            </p>
            <div className="mt-5 flex items-center gap-2 text-xs text-sidebar-foreground/65">
              <GraduationCap className="h-4 w-4 text-sidebar-primary" />
              Final Graduation Project, HCMUS
            </div>
          </section>

          <section>
            <FooterHeading>University Campuses</FooterHeading>
            <div className="mt-4 space-y-4">
              {campuses.map((campus) => (
                <div key={campus.title} className="flex items-start gap-3">
                  <MapPin className="mt-0.5 h-4 w-4 shrink-0 text-sidebar-primary" />
                  <div>
                    <p className="text-xs font-semibold text-white">{campus.title}</p>
                    <p className="mt-1 text-xs leading-5 text-sidebar-foreground/70">{campus.address}</p>
                  </div>
                </div>
              ))}
            </div>
          </section>

          <section>
            <FooterHeading>Platform</FooterHeading>
            <nav className="mt-4 grid gap-3 text-sm">
              <NavLink to="/" className="transition-colors hover:text-sidebar-primary">Home</NavLink>
              <NavLink to="/jobs" className="transition-colors hover:text-sidebar-primary">Browse Jobs</NavLink>
              <NavLink to="/job-descriptions" className="transition-colors hover:text-sidebar-primary">Job Descriptions</NavLink>
              <NavLink to="/profiles" className="transition-colors hover:text-sidebar-primary">My Profile</NavLink>
              <a href="mailto:privacyjobs.hcmus@gmail.com" className="inline-flex items-center gap-2 transition-colors hover:text-sidebar-primary">
                <Mail className="h-3.5 w-3.5" /> Contact the Project
              </a>
            </nav>
          </section>

          <section>
            <FooterHeading>Connect With Us</FooterHeading>
            <div className="mt-4 grid grid-cols-2 gap-2">
              {socialLinks.map(({ label, href, icon: Icon }) => (
                <a
                  key={label}
                  href={href}
                  target="_blank"
                  rel="noreferrer"
                  aria-label={`Open ${label}`}
                  className="flex items-center gap-2 rounded-lg border border-sidebar-border bg-sidebar-accent/50 px-3 py-2 text-xs transition-colors hover:border-sidebar-primary/40 hover:text-sidebar-primary"
                >
                  <Icon className="h-4 w-4" />
                  {label}
                </a>
              ))}
            </div>
          </section>
        </div>

        <div className="mt-10 flex flex-col gap-3 border-t border-sidebar-border pt-5 text-xs text-sidebar-foreground/55 sm:flex-row sm:items-center sm:justify-between">
          <p>© {new Date().getFullYear()} PrivacyJobs. HCMUS Graduation Project.</p>
          <p>University of Science, Vietnam National University Ho Chi Minh City</p>
        </div>
      </div>
    </footer>
  );
}

function FooterHeading({ children }: { children: React.ReactNode }) {
  return (
    <h2 className="font-display text-sm font-semibold uppercase tracking-[0.14em] text-white">
      {children}
    </h2>
  );
}
