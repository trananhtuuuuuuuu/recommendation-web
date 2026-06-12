import { FormEvent, useState } from "react";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import type { LucideIcon } from "lucide-react";
import {
  Bell,
  Bookmark,
  Briefcase,
  Building2,
  FilePlus,
  Home,
  LogIn,
  LogOut,
  Menu,
  Search,
  Shield,
  User,
  Users,
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import {
  Sheet,
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import ProfileOverview from "@/components/ProfileOverview";
import ScrollProgress from "@/components/ScrollProgress";
import SiteFooter from "@/components/SiteFooter";

interface NavigationItem {
  to: string;
  label: string;
  icon: LucideIcon;
}

export default function Layout({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, role, user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [searchQuery, setSearchQuery] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const showProfileOverview = isAuthenticated
    && (role === "APPLICANT" || role === "RECRUITER")
    && !isProfileOverviewExcluded(location.pathname, role);

  const navItems: NavigationItem[] = [
    { to: "/jobs", label: "Browse Jobs", icon: Briefcase },
  ];
  if (role === "APPLICANT") {
    navItems.push({ to: "/applicants/saved-jobs", label: "My Jobs", icon: Bookmark });
  }
  if (role === "RECRUITER") {
    navItems.push({ to: "/recruiters/jobs", label: "My Jobs", icon: FilePlus });
  }
  if (role === "ADMIN") {
    navItems.push({ to: "/admin/applicants", label: "Applicants", icon: Users });
    navItems.push({ to: "/admin/recruiters", label: "Recruiters", icon: Building2 });
  }

  const handleLogout = () => {
    setMobileMenuOpen(false);
    logout();
    navigate("/");
  };

  const handleSearch = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const query = searchQuery.trim();
    setMobileMenuOpen(false);
    navigate(query ? `/jobs?q=${encodeURIComponent(query)}` : "/jobs");
  };

  return (
    <div className="flex min-h-screen flex-col bg-background">
      <ScrollProgress />

      <header className="sticky top-0 z-40 border-b border-border/80 bg-background/90 shadow-sm backdrop-blur-xl">
        <div className="mx-auto flex h-14 w-full max-w-[1600px] items-center justify-between gap-3 px-4 lg:px-8">
          <div className="flex min-w-0 items-center gap-4">
            <NavLink to="/" className="mr-1 flex shrink-0 items-center gap-2">
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/20">
                <Shield className="h-4 w-4 text-primary" />
              </div>
              <span className="hidden font-display text-sm font-bold text-foreground sm:block">
                PrivacyJobs
              </span>
            </NavLink>
            <nav className="hidden items-center gap-1 md:flex">
              {navItems.map(({ to, label, icon: Icon }) => (
                <NavLink
                  key={to}
                  to={to}
                  className={({ isActive }) =>
                    `flex items-center gap-1.5 rounded-md px-3 py-1.5 text-xs font-medium transition-colors ${
                      isActive
                        ? "bg-primary/15 text-primary"
                        : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                    }`
                  }
                >
                  <Icon className="h-3.5 w-3.5" />
                  {label}
                </NavLink>
              ))}
            </nav>
          </div>

          <div className="flex shrink-0 items-center gap-1.5 sm:gap-2">
            <form onSubmit={handleSearch} className="relative hidden lg:block">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                type="search"
                value={searchQuery}
                onChange={(event) => setSearchQuery(event.target.value)}
                placeholder="Search jobs..."
                aria-label="Search jobs"
                className="w-56 rounded-lg border-none bg-secondary py-2 pl-9 pr-4 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:ring-2 focus:ring-primary/30"
              />
            </form>

            {isAuthenticated ? (
              <>
                <NavLink
                  to="/notifications"
                  aria-label="Notifications"
                  className="relative rounded-lg p-2 transition-colors hover:bg-secondary"
                >
                  <Bell className="h-4 w-4 text-muted-foreground" />
                  <span className="absolute right-1.5 top-1.5 h-2 w-2 rounded-full bg-primary" />
                </NavLink>
                <NavLink
                  to="/profiles"
                  className={({ isActive }) =>
                    `hidden items-center gap-2 rounded-lg px-2 py-1.5 transition-colors sm:flex ${
                      isActive ? "bg-primary/15" : "hover:bg-secondary"
                    }`
                  }
                >
                  <div className="flex h-7 w-7 items-center justify-center rounded-full bg-primary/20">
                    <User className="h-3.5 w-3.5 text-primary" />
                  </div>
                  <span className="hidden text-xs font-medium text-foreground xl:block">
                    {user?.userName ?? "Profile"}
                    {role ? <span className="ml-1 text-muted-foreground">· {role}</span> : null}
                  </span>
                </NavLink>
                <Button variant="ghost" size="sm" onClick={handleLogout} className="hidden gap-1 text-xs md:flex">
                  <LogOut className="h-3.5 w-3.5" /> Logout
                </Button>
              </>
            ) : (
              <>
                <NavLink
                  to="/auth"
                  className="hidden items-center gap-1 px-2 py-1.5 text-xs font-medium text-muted-foreground transition-colors hover:text-foreground sm:flex"
                >
                  <LogIn className="h-3.5 w-3.5" /> Sign In
                </NavLink>
                <NavLink
                  to="/applicants/registration"
                  className="hidden rounded-md bg-primary px-3 py-1.5 text-xs font-medium text-primary-foreground transition-colors hover:bg-primary/90 sm:block"
                >
                  Register
                </NavLink>
              </>
            )}

            <Sheet open={mobileMenuOpen} onOpenChange={setMobileMenuOpen}>
              <SheetTrigger asChild>
                <Button variant="ghost" size="icon" className="md:hidden" aria-label="Open navigation">
                  <Menu className="h-5 w-5" />
                </Button>
              </SheetTrigger>
              <SheetContent side="right" className="w-[min(88vw,360px)]">
                <SheetHeader>
                  <SheetTitle className="flex items-center gap-2">
                    <Shield className="h-5 w-5 text-primary" /> PrivacyJobs
                  </SheetTitle>
                  <SheetDescription>Secure job discovery and hiring tools.</SheetDescription>
                </SheetHeader>

                <form onSubmit={handleSearch} className="relative mt-6">
                  <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                  <input
                    type="search"
                    value={searchQuery}
                    onChange={(event) => setSearchQuery(event.target.value)}
                    placeholder="Search jobs..."
                    aria-label="Search jobs"
                    className="w-full rounded-lg bg-secondary py-2.5 pl-9 pr-4 text-sm outline-none focus:ring-2 focus:ring-primary/30"
                  />
                </form>

                <nav className="mt-6 space-y-1">
                  {[{ to: "/", label: "Home", icon: Home }, ...navItems].map(({ to, label, icon: Icon }) => (
                    <SheetClose asChild key={to}>
                      <NavLink
                        to={to}
                        className={({ isActive }) =>
                          `flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium ${
                            isActive ? "bg-primary/10 text-primary" : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                          }`
                        }
                      >
                        <Icon className="h-4 w-4" />
                        {label}
                      </NavLink>
                    </SheetClose>
                  ))}
                  {isAuthenticated ? (
                    <>
                      <SheetClose asChild>
                        <NavLink to="/profiles" className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-muted-foreground hover:bg-secondary hover:text-foreground">
                          <User className="h-4 w-4" /> Profile
                        </NavLink>
                      </SheetClose>
                      <Button variant="ghost" className="w-full justify-start gap-3 px-3 text-muted-foreground" onClick={handleLogout}>
                        <LogOut className="h-4 w-4" /> Logout
                      </Button>
                    </>
                  ) : (
                    <>
                      <SheetClose asChild>
                        <NavLink to="/auth" className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-muted-foreground hover:bg-secondary hover:text-foreground">
                          <LogIn className="h-4 w-4" /> Sign In
                        </NavLink>
                      </SheetClose>
                      <SheetClose asChild>
                        <NavLink to="/applicants/registration" className="mt-3 block rounded-lg bg-primary px-3 py-2.5 text-center text-sm font-medium text-primary-foreground">
                          Create applicant account
                        </NavLink>
                      </SheetClose>
                    </>
                  )}
                </nav>
              </SheetContent>
            </Sheet>
          </div>
        </div>
      </header>

      <main className="min-h-[calc(100vh-3.5rem)] flex-1 p-4 lg:p-8">
        {showProfileOverview ? (
          <div className="mx-auto grid max-w-[1600px] items-start gap-6 xl:grid-cols-[minmax(0,1fr)_300px]">
            <div className="order-2 min-w-0 xl:order-1 xl:col-start-1 xl:row-start-1">{children}</div>
            <div className="order-1 min-w-0 xl:order-2 xl:col-start-2 xl:row-start-1">
              <ProfileOverview />
            </div>
          </div>
        ) : children}
      </main>

      <SiteFooter />
    </div>
  );
}

function isProfileOverviewExcluded(pathname: string, role: string | null) {
  if (pathname === "/profiles") return true;
  if (role === "APPLICANT" && pathname === "/applicants/saved-jobs") return true;
  if (role === "RECRUITER" && pathname === "/recruiters/jobs") return true;
  return false;
}
