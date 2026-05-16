import { NavLink, useNavigate } from "react-router-dom";
import {
  Shield, Briefcase, Users, User, Bell,
  Building2, Search, Bookmark, FilePlus, LogOut, LogIn
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";

export default function Layout({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, role, user, logout } = useAuth();
  const navigate = useNavigate();

  const navItems: { to: string; label: string; icon: any }[] = [
    { to: "/jobs", label: "Browse Jobs", icon: Briefcase },
  ];
  if (role === "APPLICANT") {
    navItems.push({ to: "/applicants/saved-jobs", label: "Saved Jobs", icon: Bookmark });
  }
  if (role === "RECRUITER") {
    navItems.push({ to: "/recruiters/jobs", label: "My Jobs", icon: FilePlus });
  }
  if (role === "ADMIN") {
    navItems.push({ to: "/admin/applicants", label: "Applicants", icon: Users });
    navItems.push({ to: "/admin/recruiters", label: "Recruiters", icon: Building2 });
  }

  const handleLogout = () => {
    logout();
    navigate("/");
  };

  return (
    <div className="min-h-screen bg-background">
      <header className="sticky top-0 z-20 bg-background/80 backdrop-blur-lg border-b border-border">
        <div className="flex items-center justify-between px-4 lg:px-8 h-14">
          <div className="flex items-center gap-4">
            <NavLink to="/" className="flex items-center gap-2 mr-2">
              <div className="w-8 h-8 rounded-lg bg-primary/20 flex items-center justify-center">
                <Shield className="w-4 h-4 text-primary" />
              </div>
              <span className="font-display text-sm font-bold text-foreground hidden sm:block">
                PrivacyJobs
              </span>
            </NavLink>
            <nav className="hidden md:flex items-center gap-1">
              {navItems.map(({ to, label, icon: Icon }) => (
                <NavLink
                  key={to}
                  to={to}
                  className={({ isActive }) =>
                    `flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-medium transition-colors ${
                      isActive
                        ? "bg-primary/15 text-primary"
                        : "text-muted-foreground hover:text-foreground hover:bg-secondary"
                    }`
                  }
                >
                  <Icon className="w-3.5 h-3.5" />
                  {label}
                </NavLink>
              ))}
            </nav>
          </div>
          <div className="flex items-center gap-2">
            <div className="relative hidden sm:block">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <input
                type="text"
                placeholder="Search jobs..."
                className="pl-9 pr-4 py-2 text-sm bg-secondary rounded-lg border-none outline-none focus:ring-2 focus:ring-primary/30 w-56 text-foreground placeholder:text-muted-foreground"
              />
            </div>

            {isAuthenticated ? (
              <>
                <NavLink
                  to="/notifications"
                  className="relative p-2 rounded-lg hover:bg-secondary transition-colors"
                >
                  <Bell className="w-4 h-4 text-muted-foreground" />
                  <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-primary" />
                </NavLink>
                <NavLink
                  to="/profiles"
                  className={({ isActive }) =>
                    `flex items-center gap-2 px-2 py-1.5 rounded-lg transition-colors ${
                      isActive ? "bg-primary/15" : "hover:bg-secondary"
                    }`
                  }
                >
                  <div className="w-7 h-7 rounded-full bg-primary/20 flex items-center justify-center">
                    <User className="w-3.5 h-3.5 text-primary" />
                  </div>
                  <span className="hidden lg:block text-xs font-medium text-foreground">
                    {user?.userName ?? "Profile"}
                    {role && <span className="ml-1 text-muted-foreground">· {role}</span>}
                  </span>
                </NavLink>
                <Button variant="ghost" size="sm" onClick={handleLogout} className="gap-1 text-xs">
                  <LogOut className="w-3.5 h-3.5" /> Logout
                </Button>
              </>
            ) : (
              <>
                <NavLink
                  to="/auth"
                  className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium text-muted-foreground hover:text-foreground transition-colors"
                >
                  <LogIn className="w-3.5 h-3.5" /> Sign In
                </NavLink>
                <NavLink
                  to="/applicants/registration"
                  className="px-3 py-1.5 text-xs font-medium bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors"
                >
                  Register
                </NavLink>
              </>
            )}
          </div>
        </div>
      </header>

      <main className="p-4 lg:p-8">{children}</main>
    </div>
  );
}
