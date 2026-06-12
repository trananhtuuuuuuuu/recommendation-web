import { lazy, Suspense } from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Loader2 } from "lucide-react";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import Layout from "./components/Layout";
import RouteGuard from "./components/RouteGuard";
import { AuthProvider } from "./contexts/AuthContext";
import Forbidden from "./pages/Forbidden";

const Index = lazy(() => import("./pages/Index"));
const Jobs = lazy(() => import("./pages/Jobs"));
const JobDetail = lazy(() => import("./pages/JobDetail"));
const JobApplicants = lazy(() => import("./pages/JobApplicants"));
const JobDescriptions = lazy(() => import("./pages/JobDescriptions"));
const Recruiters = lazy(() => import("./pages/Recruiters"));
const RecruiterDetail = lazy(() => import("./pages/RecruiterDetail"));
const RecruiterJobs = lazy(() => import("./pages/RecruiterJobs"));
const PostEditJob = lazy(() => import("./pages/PostEditJob"));
const Applicants = lazy(() => import("./pages/Applicants"));
const ApplicantDetail = lazy(() => import("./pages/ApplicantDetail"));
const Profile = lazy(() => import("./pages/Profile"));
const SavedJobs = lazy(() => import("./pages/SavedJobs"));
const Notifications = lazy(() => import("./pages/Notifications"));
const NotFound = lazy(() => import("./pages/NotFound"));
const ApplicantRegistration = lazy(() => import("./pages/ApplicantRegistration"));
const ApplicantAuth = lazy(() => import("./pages/ApplicantAuth"));
const RecruiterRegistration = lazy(() => import("./pages/RecruiterRegistration"));
const RecruiterAuth = lazy(() => import("./pages/RecruiterAuth"));
const Auth = lazy(() => import("./pages/Auth"));

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <AuthProvider>
          <Layout>
            <Suspense fallback={<RouteLoading />}>
              <Routes>
                {/* Public */}
                <Route path="/" element={<Index />} />
                <Route path="/jobs" element={<Jobs />} />
                <Route path="/jobs/:id" element={<JobDetail />} />
                <Route path="/job-descriptions" element={<JobDescriptions />} />
                <Route path="/auth" element={<Auth />} />
                <Route path="/forbidden" element={<Forbidden />} />
                <Route path="/applicants/registration" element={<ApplicantRegistration />} />
                <Route path="/applicants/auth" element={<ApplicantAuth />} />
                <Route path="/recruiters/registration" element={<RecruiterRegistration />} />
                <Route path="/recruiters/auth" element={<RecruiterAuth />} />

                {/* Authenticated (any role) */}
                <Route path="/profiles" element={<RouteGuard><Profile /></RouteGuard>} />
                <Route path="/notifications" element={<RouteGuard><Notifications /></RouteGuard>} />

                {/* Applicant-only */}
                <Route path="/applicants/saved-jobs" element={
                  <RouteGuard roles={["APPLICANT"]}><SavedJobs /></RouteGuard>
                } />
                <Route path="/applicants/:id" element={
                  <RouteGuard roles={["APPLICANT", "RECRUITER", "ADMIN"]}><ApplicantDetail /></RouteGuard>
                } />

                {/* Recruiter-only */}
                <Route path="/recruiters/jobs" element={
                  <RouteGuard roles={["RECRUITER"]}><RecruiterJobs /></RouteGuard>
                } />
                <Route path="/recruiters/jobs/new" element={
                  <RouteGuard roles={["RECRUITER"]}><PostEditJob /></RouteGuard>
                } />
                <Route path="/recruiters/jobs/:id/edit" element={
                  <RouteGuard roles={["RECRUITER"]}><PostEditJob /></RouteGuard>
                } />
                <Route path="/jobs/:jobId/applicants" element={
                  <RouteGuard roles={["RECRUITER", "ADMIN"]}><JobApplicants /></RouteGuard>
                } />
                <Route path="/recruiters/:id" element={
                  <RouteGuard roles={["APPLICANT", "RECRUITER", "ADMIN"]}><RecruiterDetail /></RouteGuard>
                } />

                {/* Admin-only */}
                <Route path="/admin/applicants" element={
                  <RouteGuard roles={["ADMIN"]}><Applicants /></RouteGuard>
                } />
                <Route path="/admin/recruiters" element={
                  <RouteGuard roles={["ADMIN"]}><Recruiters /></RouteGuard>
                } />
                {/* Legacy / public-ish list aliases */}
                <Route path="/applicants" element={
                  <RouteGuard roles={["ADMIN"]}><Applicants /></RouteGuard>
                } />
                <Route path="/recruiters" element={
                  <RouteGuard roles={["ADMIN"]}><Recruiters /></RouteGuard>
                } />

                <Route path="*" element={<NotFound />} />
              </Routes>
            </Suspense>
          </Layout>
        </AuthProvider>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

function RouteLoading() {
  return (
    <div className="flex min-h-[55vh] items-center justify-center text-muted-foreground">
      <Loader2 className="h-5 w-5 animate-spin" />
      <span className="sr-only">Loading page</span>
    </div>
  );
}

export default App;
