import type { LucideIcon } from "lucide-react";
import { CheckCircle2, LockKeyhole, ShieldCheck } from "lucide-react";

interface AuthPageShellProps {
  eyebrow: string;
  title: string;
  description: string;
  icon: LucideIcon;
  points: string[];
  children: React.ReactNode;
  wide?: boolean;
}

export default function AuthPageShell({
  eyebrow,
  title,
  description,
  icon: Icon,
  points,
  children,
  wide = false,
}: AuthPageShellProps) {
  return (
    <div className={`mx-auto grid min-h-[calc(100vh-9rem)] items-center gap-6 py-4 lg:grid-cols-[0.8fr_1.2fr] ${wide ? "max-w-7xl" : "max-w-5xl"}`}>
      <aside
        className="relative overflow-hidden rounded-2xl border border-primary/20 p-6 text-primary-foreground sm:p-8 lg:sticky lg:top-24 lg:p-10"
        style={{ background: "var(--gradient-hero)" }}
      >
        <div className="absolute -right-16 -top-16 h-56 w-56 rounded-full bg-primary/25 blur-3xl" />
        <div className="absolute -bottom-20 -left-16 h-56 w-56 rounded-full bg-accent/20 blur-3xl" />
        <div className="relative">
          <div className="mb-8 inline-flex items-center gap-2 rounded-full border border-primary/25 bg-primary/15 px-3 py-1.5 text-xs font-medium text-primary">
            <ShieldCheck className="h-3.5 w-3.5" />
            {eyebrow}
          </div>
          <div className="mb-5 flex h-12 w-12 items-center justify-center rounded-xl bg-primary/15 ring-1 ring-primary/25">
            <Icon className="h-6 w-6 text-primary" />
          </div>
          <h1 className="max-w-xl font-display text-3xl font-bold leading-tight sm:text-4xl">{title}</h1>
          <p className="mt-4 max-w-xl text-sm leading-6 text-primary-foreground/70 sm:text-base">{description}</p>

          <div className="mt-8 grid gap-3 sm:grid-cols-2 lg:grid-cols-1">
            {points.map((point) => (
              <div key={point} className="flex items-start gap-3 rounded-lg border border-primary-foreground/10 bg-primary-foreground/5 p-3">
                <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-primary" />
                <span className="text-sm text-primary-foreground/80">{point}</span>
              </div>
            ))}
          </div>

          <div className="mt-8 flex items-center gap-2 text-xs text-primary-foreground/60">
            <LockKeyhole className="h-3.5 w-3.5 text-primary" />
            Authentication data is sent only through the configured backend API.
          </div>
        </div>
      </aside>

      <div className="min-w-0">{children}</div>
    </div>
  );
}
