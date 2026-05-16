import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import Layout from "./components/Layout";
import RouteGuard from "./components/RouteGuard";
import { AuthProvider } from "./contexts/AuthContext";
import Index from "./pages/Index";
import Jobs from "./pages/Jobs";
import JobDetail from "./pages/JobDetail";
import JobApplicants from "./pages/JobApplicants";
import JobDescriptions from "./pages/JobDescriptions";
import Recruiters from "./pages/Recruiters";
import RecruiterDetail from "./pages/RecruiterDetail";
import RecruiterJobs from "./pages/RecruiterJobs";
import PostEditJob from "./pages/PostEditJob";
import Applicants from "./pages/Applicants";
import ApplicantDetail from "./pages/ApplicantDetail";
import Profile from "./pages/Profile";
import SavedJobs from "./pages/SavedJobs";
import Notifications from "./pages/Notifications";
import NotFound from "./pages/NotFound";
import Forbidden from "./pages/Forbidden";
import ApplicantRegistration from "./pages/ApplicantRegistration";
import ApplicantAuth from "./pages/ApplicantAuth";
import RecruiterRegistration from "./pages/RecruiterRegistration";
import RecruiterAuth from "./pages/RecruiterAuth";
import Auth from "./pages/Auth";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <AuthProvider>
          <Layout>
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
                <RouteGuard roles={["APPLICANT", "ADMIN"]}><ApplicantDetail /></RouteGuard>
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
                <RouteGuard roles={["RECRUITER", "ADMIN"]}><RecruiterDetail /></RouteGuard>
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
          </Layout>
        </AuthProvider>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
