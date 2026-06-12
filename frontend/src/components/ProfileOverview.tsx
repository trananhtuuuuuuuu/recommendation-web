import { useQuery } from "@tanstack/react-query";
import {
  ArrowRight,
  BriefcaseBusiness,
  Building2,
  FileText,
  Mail,
  MapPin,
  ShieldCheck,
  User,
} from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import {
  fetchApplicant,
  fetchRecruiter,
  type Applicant,
  type Recruiter,
} from "@/lib/jobsApi";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Skeleton } from "@/components/ui/skeleton";
import { readProfileAvatar } from "@/lib/profileAvatar";

export default function ProfileOverview() {
  const { user, role } = useAuth();
  const avatarUrl = readProfileAvatar(role, user?.id);
  const profileQuery = useQuery({
    queryKey: ["profile-overview", role, user?.id],
    queryFn: () => role === "RECRUITER" ? fetchRecruiter(user!.id!) : fetchApplicant(user!.id!),
    enabled: Boolean(user?.id && (role === "APPLICANT" || role === "RECRUITER")),
  });

  if (profileQuery.isLoading) {
    return <ProfileOverviewSkeleton />;
  }

  if (role === "RECRUITER") {
    return <RecruiterOverview recruiter={profileQuery.data as Recruiter | undefined} fallbackName={user?.userName} avatarUrl={avatarUrl} />;
  }

  return <ApplicantOverview applicant={profileQuery.data as Applicant | undefined} fallbackName={user?.userName} avatarUrl={avatarUrl} />;
}

function ApplicantOverview({
  applicant,
  fallbackName,
  avatarUrl,
}: {
  applicant?: Applicant;
  fallbackName?: string | null;
  avatarUrl: string;
}) {
  const name = applicant?.fullName || applicant?.userName || fallbackName || "Applicant";
  const skills = toList(applicant?.cv?.skills);
  const completion = completionPercentage([
    name,
    applicant?.email,
    applicant?.phone,
    applicant?.address,
    applicant?.status,
    applicant?.cv?.objective,
    applicant?.cv?.skills,
    applicant?.cv?.experience,
    applicant?.cv?.education,
    applicant?.cv?.cvFileUrl,
  ]);

  return (
    <OverviewCard
      icon={User}
      imageUrl={avatarUrl}
      name={name}
      subtitle={applicant?.status || "Applicant account"}
      badge="Applicant"
      completion={completion}
      primaryHref="/profiles"
      primaryLabel="Open full profile"
      secondaryHref="/applicants/saved-jobs"
      secondaryLabel="My jobs"
    >
      <OverviewItem icon={Mail} label="Email" value={applicant?.email} />
      <OverviewItem icon={MapPin} label="Location" value={applicant?.address} />
      <OverviewItem
        icon={FileText}
        label="CV readiness"
        value={applicant?.cv ? `${skills.length} skill${skills.length === 1 ? "" : "s"} listed` : "CV not uploaded"}
      />
      {skills.length > 0 ? (
        <div className="flex flex-wrap gap-1.5 pt-1">
          {skills.slice(0, 4).map((skill) => (
            <Badge key={skill} variant="secondary" className="max-w-full truncate text-[10px]">
              {skill}
            </Badge>
          ))}
        </div>
      ) : null}
    </OverviewCard>
  );
}

function RecruiterOverview({
  recruiter,
  fallbackName,
  avatarUrl,
}: {
  recruiter?: Recruiter;
  fallbackName?: string | null;
  avatarUrl: string;
}) {
  const name = recruiter?.companyName || recruiter?.userName || fallbackName || "Recruiter";
  const completion = completionPercentage([
    name,
    recruiter?.email,
    recruiter?.companyDescription,
    recruiter?.companyLocation || recruiter?.address,
    recruiter?.companySize,
    recruiter?.industry,
    recruiter?.website,
    recruiter?.contactEmail,
    recruiter?.contactPhone,
    recruiter?.logoUrl,
  ]);

  return (
    <OverviewCard
      icon={Building2}
      imageUrl={avatarUrl || recruiter?.logoUrl}
      name={name}
      subtitle={recruiter?.industry || "Recruiter account"}
      badge="Recruiter"
      completion={completion}
      primaryHref="/profiles"
      primaryLabel="Open company profile"
      secondaryHref="/recruiters/jobs"
      secondaryLabel="Job dashboard"
    >
      <OverviewItem icon={Mail} label="Hiring contact" value={recruiter?.contactEmail || recruiter?.email} />
      <OverviewItem icon={MapPin} label="Location" value={recruiter?.companyLocation || recruiter?.address} />
      <OverviewItem icon={BriefcaseBusiness} label="Company size" value={recruiter?.companySize} />
      {recruiter?.companyDescription ? (
        <p className="line-clamp-3 pt-1 text-xs leading-5 text-muted-foreground">
          {recruiter.companyDescription}
        </p>
      ) : null}
    </OverviewCard>
  );
}

function OverviewCard({
  icon: Icon,
  imageUrl,
  name,
  subtitle,
  badge,
  completion,
  primaryHref,
  primaryLabel,
  secondaryHref,
  secondaryLabel,
  children,
}: {
  icon: LucideIcon;
  imageUrl?: string;
  name: string;
  subtitle: string;
  badge: string;
  completion: number;
  primaryHref: string;
  primaryLabel: string;
  secondaryHref: string;
  secondaryLabel: string;
  children: React.ReactNode;
}) {
  return (
    <aside className="rounded-xl border bg-card shadow-sm xl:sticky xl:top-20">
      <div className="relative overflow-hidden rounded-t-xl bg-[linear-gradient(135deg,hsl(var(--primary)/0.18),hsl(var(--trust)/0.12),hsl(var(--accent)/0.12))] p-5">
        <div className="absolute -right-8 -top-10 h-28 w-28 rounded-full bg-primary/20 blur-2xl" />
        <div className="relative flex items-start gap-3">
          <span className="flex h-12 w-12 shrink-0 items-center justify-center overflow-hidden rounded-xl border border-primary/20 bg-card/90 text-primary shadow-sm">
            {imageUrl ? <img src={imageUrl} alt="" className="h-full w-full object-cover" /> : <Icon className="h-5 w-5" />}
          </span>
          <div className="min-w-0 flex-1">
            <Badge className="mb-2 bg-primary/10 text-[10px] text-primary hover:bg-primary/10">
              <ShieldCheck className="mr-1 h-3 w-3" /> {badge}
            </Badge>
            <h2 className="truncate font-display text-base font-bold text-foreground">{name}</h2>
            <p className="mt-0.5 truncate text-xs text-muted-foreground">{subtitle}</p>
          </div>
        </div>
      </div>

      <div className="space-y-5 p-5">
        <div>
          <div className="mb-2 flex items-center justify-between gap-3 text-xs">
            <span className="font-medium text-foreground">Profile completeness</span>
            <span className="font-semibold text-primary">{completion}%</span>
          </div>
          <Progress value={completion} className="h-1.5" />
          {completion < 100 ? (
            <p className="mt-2 text-[11px] leading-4 text-muted-foreground">
              Add missing details from your profile to improve this overview.
            </p>
          ) : null}
        </div>

        <div className="space-y-3">{children}</div>

        <div className="grid gap-2 border-t pt-4">
          <Button asChild size="sm" className="w-full justify-between">
            <Link to={primaryHref}>
              {primaryLabel}
              <ArrowRight className="h-3.5 w-3.5" />
            </Link>
          </Button>
          <Button asChild size="sm" variant="outline" className="w-full">
            <Link to={secondaryHref}>{secondaryLabel}</Link>
          </Button>
        </div>
      </div>
    </aside>
  );
}

function OverviewItem({
  icon: Icon,
  label,
  value,
}: {
  icon: LucideIcon;
  label: string;
  value?: string | null;
}) {
  return (
    <div className="flex items-start gap-3">
      <span className="mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-secondary text-primary">
        <Icon className="h-3.5 w-3.5" />
      </span>
      <div className="min-w-0">
        <p className="text-[10px] uppercase tracking-wide text-muted-foreground">{label}</p>
        <p className="truncate text-xs font-medium text-foreground">{value || "Not provided"}</p>
      </div>
    </div>
  );
}

function ProfileOverviewSkeleton() {
  return (
    <aside className="rounded-xl border bg-card p-5 shadow-sm xl:sticky xl:top-20">
      <div className="flex items-center gap-3">
        <Skeleton className="h-12 w-12 rounded-xl" />
        <div className="flex-1 space-y-2">
          <Skeleton className="h-4 w-2/3" />
          <Skeleton className="h-3 w-1/2" />
        </div>
      </div>
      <div className="mt-6 space-y-4">
        <Skeleton className="h-2 w-full" />
        <Skeleton className="h-9 w-full" />
        <Skeleton className="h-9 w-full" />
        <Skeleton className="h-9 w-full" />
      </div>
    </aside>
  );
}

function completionPercentage(values: unknown[]) {
  const completed = values.filter((value) => {
    if (typeof value === "string") return value.trim().length > 0;
    return value !== null && value !== undefined;
  }).length;
  return Math.round((completed / values.length) * 100);
}

function toList(value?: string | null) {
  return (value || "")
    .split(/\r?\n|,/)
    .map((item) => item.trim())
    .filter(Boolean);
}
