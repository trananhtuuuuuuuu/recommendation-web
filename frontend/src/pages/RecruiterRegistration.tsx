import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Building2, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { registerRecruiter } from "@/lib/jobsApi";
import { ApiError } from "@/lib/api";
import AuthPageShell from "@/components/AuthPageShell";

const initial = {
  // account
  userName: "", email: "", password: "", confirmPassword: "", phone: "", address: "",
  // company
  companyName: "", taxCode: "", establishedDate: "", companyDescription: "",
  companyLocation: "", companySize: "", industry: "", website: "", logoUrl: "",
  companyType: "", businessLicense: "",
  // contact
  contactEmail: "", contactPhone: "",
};

export default function RecruiterRegistration() {
  const navigate = useNavigate();
  const [form, setForm] = useState(initial);
  const [loading, setLoading] = useState(false);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});
  const [globalError, setGlobalError] = useState<string | null>(null);

  const update = (k: keyof typeof initial, v: string) => setForm({ ...form, [k]: v });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setFieldErrors({});
    setGlobalError(null);
    if (form.password !== form.confirmPassword) {
      setFieldErrors({ confirmPassword: "Passwords do not match" });
      return;
    }
    setLoading(true);
    try {
      const { confirmPassword, ...payload } = form;
      await registerRecruiter({ ...payload, roleName: "RECRUITER" });
      toast.success("Recruiter account created. Please sign in.");
      navigate("/auth");
    } catch (err) {
      if (err instanceof ApiError) {
        if (err.errors && !Array.isArray(err.errors)) {
          setFieldErrors(err.errors as Record<string, string>);
        }
        setGlobalError(err.message);
        toast.error(err.message);
      } else toast.error("Registration failed");
    } finally {
      setLoading(false);
    }
  };

  const field = (
    name: keyof typeof initial,
    label: string,
    opts: { type?: string; placeholder?: string; required?: boolean; textarea?: boolean } = {}
  ) => (
    <div className="space-y-1.5">
      <Label htmlFor={name}>{label}</Label>
      {opts.textarea ? (
        <Textarea id={name} value={form[name]} onChange={(e) => update(name, e.target.value)} placeholder={opts.placeholder} />
      ) : (
        <Input
          id={name}
          type={opts.type ?? "text"}
          required={opts.required}
          value={form[name]}
          onChange={(e) => update(name, e.target.value)}
          placeholder={opts.placeholder}
        />
      )}
      {fieldErrors[name] && <p className="text-xs text-destructive">{fieldErrors[name]}</p>}
    </div>
  );

  return (
    <AuthPageShell
      eyebrow="Recruiter onboarding"
      title="Create a credible company presence before publishing roles."
      description="Company details collected here support richer job posts, clearer candidate context, and a more trustworthy hiring experience."
      icon={Building2}
      points={[
        "Manage company identity and hiring contacts together.",
        "Publish structured roles with custom applicant questions.",
        "Review candidates from a recruiter-only workspace.",
      ]}
      wide
    >
      <motion.div initial={{ opacity: 0, y: 24 }} animate={{ opacity: 1, y: 0 }} className="w-full">
        <form onSubmit={handleSubmit} className="space-y-6 rounded-2xl border border-border bg-card p-6 shadow-lg sm:p-8">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-accent/20 flex items-center justify-center">
              <Building2 className="w-5 h-5 text-accent" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-foreground">Recruiter Registration</h1>
              <p className="text-sm text-muted-foreground">Create your recruiter & company account</p>
            </div>
          </div>

          {globalError && (
            <div className="text-xs text-destructive bg-destructive/10 border border-destructive/20 rounded-md px-3 py-2">
              {globalError}
            </div>
          )}

          <section className="space-y-3">
            <h2 className="text-sm font-semibold text-foreground">Personal Account</h2>
            <div className="grid sm:grid-cols-2 gap-3">
              {field("userName", "Username", { required: true })}
              {field("email", "Email", { type: "email", required: true })}
              {field("password", "Password", { type: "password", required: true })}
              {field("confirmPassword", "Confirm Password", { type: "password", required: true })}
              {field("phone", "Phone")}
              {field("address", "Address")}
            </div>
          </section>

          <section className="space-y-3">
            <h2 className="text-sm font-semibold text-foreground">Company Information</h2>
            <div className="grid sm:grid-cols-2 gap-3">
              {field("companyName", "Company Name", { required: true })}
              {field("taxCode", "Tax Code")}
              {field("establishedDate", "Established Date", { type: "date" })}
              {field("industry", "Industry")}
              {field("companySize", "Company Size", { placeholder: "e.g. 50-200" })}
              {field("companyType", "Company Type")}
              {field("companyLocation", "Company Location")}
              {field("website", "Website", { placeholder: "https://..." })}
              {field("logoUrl", "Logo URL")}
              {field("businessLicense", "Business License")}
            </div>
            {field("companyDescription", "Company Description", { textarea: true })}
          </section>

          <section className="space-y-3">
            <h2 className="text-sm font-semibold text-foreground">Contact Information</h2>
            <div className="grid sm:grid-cols-2 gap-3">
              {field("contactEmail", "Contact Email", { type: "email" })}
              {field("contactPhone", "Contact Phone")}
            </div>
          </section>

          <Button type="submit" disabled={loading} className="w-full bg-accent hover:bg-accent/90 gap-2">
            {loading && <Loader2 className="w-4 h-4 animate-spin" />}
            {loading ? "Creating..." : "Create Recruiter Account"}
          </Button>

          <p className="text-center text-sm text-muted-foreground">
            Already have an account?{" "}
            <Link to="/auth" className="text-accent hover:underline font-medium">Sign in</Link>
          </p>
        </form>
      </motion.div>
    </AuthPageShell>
  );
}
