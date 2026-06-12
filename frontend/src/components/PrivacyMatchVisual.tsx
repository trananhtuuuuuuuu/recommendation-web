import {
  Building2,
  CheckCircle2,
  LockKeyhole,
  ShieldCheck,
  UserRoundCheck,
} from "lucide-react";

export default function PrivacyMatchVisual() {
  return (
    <div
      className="relative mx-auto aspect-square w-full max-w-[390px]"
      aria-label="Private candidate matching visualization"
    >
      <div className="match-orbit-ring absolute inset-[8%] rounded-full border border-primary/20" />
      <div className="match-orbit-ring match-orbit-ring-reverse absolute inset-[22%] rounded-full border border-trust/25" />

      <div className="match-signal absolute left-1/2 top-1/2 h-[72%] w-px -translate-x-1/2 -translate-y-1/2 bg-gradient-to-b from-transparent via-primary/35 to-transparent" />
      <div className="match-signal absolute left-1/2 top-1/2 h-px w-[72%] -translate-x-1/2 -translate-y-1/2 bg-gradient-to-r from-transparent via-trust/35 to-transparent" />

      <div className="interactive-surface absolute left-0 top-[16%] w-[145px] rounded-xl border border-white/10 bg-slate-950/70 p-3 shadow-2xl backdrop-blur-xl sm:w-[158px]">
        <div className="flex items-center gap-2.5">
          <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-primary/15 text-primary">
            <UserRoundCheck className="h-4 w-4" />
          </span>
          <div className="min-w-0">
            <p className="text-[10px] font-semibold uppercase tracking-[0.16em] text-primary">Applicant</p>
            <p className="truncate text-xs font-medium text-white">Private profile</p>
          </div>
        </div>
      </div>

      <div className="interactive-surface absolute right-0 top-[16%] w-[145px] rounded-xl border border-white/10 bg-slate-950/70 p-3 shadow-2xl backdrop-blur-xl sm:w-[158px]">
        <div className="flex items-center gap-2.5">
          <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-trust/15 text-trust">
            <Building2 className="h-4 w-4" />
          </span>
          <div className="min-w-0">
            <p className="text-[10px] font-semibold uppercase tracking-[0.16em] text-trust">Recruiter</p>
            <p className="truncate text-xs font-medium text-white">Verified employer</p>
          </div>
        </div>
      </div>

      <div className="match-core absolute left-1/2 top-1/2 flex h-28 w-28 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full border border-primary/30 bg-slate-950/80 shadow-[0_0_70px_hsl(var(--primary)/0.28)] backdrop-blur-xl">
        <div className="flex h-20 w-20 items-center justify-center rounded-full border border-primary/25 bg-primary/10">
          <ShieldCheck className="h-9 w-9 text-primary" />
        </div>
      </div>

      <div className="interactive-surface absolute inset-x-[8%] bottom-[5%] rounded-xl border border-white/10 bg-slate-950/75 p-4 shadow-2xl backdrop-blur-xl">
        <div className="flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/15 text-primary">
              <LockKeyhole className="h-4 w-4" />
            </span>
            <div>
              <p className="text-xs font-semibold text-white">Consent-controlled matching</p>
              <p className="mt-0.5 text-[11px] text-slate-400">Identity stays protected until approval</p>
            </div>
          </div>
          <CheckCircle2 className="h-5 w-5 shrink-0 text-primary" />
        </div>
      </div>

      <span className="match-pulse absolute left-[12%] top-1/2 h-2 w-2 rounded-full bg-primary shadow-[0_0_16px_hsl(var(--primary))]" />
      <span className="match-pulse match-pulse-delayed absolute right-[12%] top-1/2 h-2 w-2 rounded-full bg-trust shadow-[0_0_16px_hsl(var(--trust))]" />
    </div>
  );
}
