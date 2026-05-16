import { motion } from "framer-motion";
import { Shield, LogIn, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { ApiError } from "@/lib/api";
import { toast } from "sonner";

export default function Auth() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation() as { state?: { from?: string } };
  const [userName, setUserName] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});
  const [globalError, setGlobalError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setFieldErrors({});
    setGlobalError(null);
    try {
      const u = await login({ userName: userName.trim(), password });
      toast.success("Welcome back!");
      const from = location.state?.from;
      if (from) navigate(from, { replace: true });
      else if (u.role === "RECRUITER") navigate("/recruiters/jobs", { replace: true });
      else if (u.role === "ADMIN") navigate("/admin/applicants", { replace: true });
      else navigate("/jobs", { replace: true });
    } catch (err) {
      if (err instanceof ApiError) {
        if (err.status === 400 && err.errors && !Array.isArray(err.errors)) {
          setFieldErrors(err.errors as Record<string, string>);
        }
        setGlobalError(err.message);
        toast.error(err.message);
      } else {
        setGlobalError("Unexpected error");
        toast.error("Unexpected error");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto pt-12">
      <motion.form
        onSubmit={handleSubmit}
        initial={{ opacity: 0, y: 15 }}
        animate={{ opacity: 1, y: 0 }}
        className="glass-card rounded-xl p-6 space-y-5"
      >
        <div className="text-center space-y-2">
          <div className="w-12 h-12 rounded-xl bg-primary/15 flex items-center justify-center mx-auto">
            <Shield className="w-6 h-6 text-primary" />
          </div>
          <h1 className="font-display text-2xl font-bold text-foreground">Sign In</h1>
          <p className="text-sm text-muted-foreground">Login to your account</p>
        </div>

        {globalError && (
          <div className="text-xs text-destructive bg-destructive/10 border border-destructive/20 rounded-md px-3 py-2">
            {globalError}
          </div>
        )}

        <div className="space-y-3">
          <div className="space-y-1.5">
            <Label>Username</Label>
            <Input
              value={userName}
              onChange={(e) => setUserName(e.target.value)}
              placeholder="your username"
              required
              autoComplete="username"
            />
            {fieldErrors.userName && (
              <p className="text-xs text-destructive">{fieldErrors.userName}</p>
            )}
          </div>
          <div className="space-y-1.5">
            <Label>Password</Label>
            <Input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              required
              autoComplete="current-password"
            />
            {fieldErrors.password && (
              <p className="text-xs text-destructive">{fieldErrors.password}</p>
            )}
          </div>
        </div>

        <Button
          type="submit"
          disabled={loading}
          className="w-full bg-primary text-primary-foreground hover:bg-primary/90 gap-2"
        >
          {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <LogIn className="w-4 h-4" />}
          {loading ? "Signing in..." : "Sign In"}
        </Button>

        <div className="text-center text-xs text-muted-foreground space-y-1">
          <p>Don't have an account?</p>
          <div className="flex justify-center gap-3">
            <Link to="/applicants/registration" className="text-primary hover:underline">
              Register as Applicant
            </Link>
            <span>·</span>
            <Link to="/recruiters/registration" className="text-primary hover:underline">
              Register as Recruiter
            </Link>
          </div>
        </div>
      </motion.form>
    </div>
  );
}
