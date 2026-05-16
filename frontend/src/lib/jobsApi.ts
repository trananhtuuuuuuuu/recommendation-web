import { apiRequest } from "@/lib/api";

export interface Job {
  jobId?: string | number;
  id?: string | number;
  jobTitle?: string;
  title?: string;
  aboutCompany?: string;
  jobDescription?: string;
  description?: string;
  requirements?: string;
  benefits?: string;
  location?: string;
  salaryRange?: string;
  jobType?: string;
  experienceLevel?: string;
  industry?: string;
  postedDate?: string;
  applicationDeadline?: string;
  startDate?: string;
  endDate?: string;
  companyName?: string;
  recruiterId?: string | number;
  recruiterName?: string;
  [k: string]: any;
}

export interface Applicant {
  id?: string | number;
  userName?: string;
  email?: string;
  fullName?: string;
  phone?: string;
  address?: string;
  gender?: string;
  status?: string;
  cvId?: string | number | null;
  [k: string]: any;
}

export interface Recruiter {
  id?: string | number;
  userName?: string;
  email?: string;
  companyName?: string;
  companyDescription?: string;
  companyLocation?: string;
  companySize?: string;
  industry?: string;
  website?: string;
  logoUrl?: string;
  contactEmail?: string;
  contactPhone?: string;
  taxCode?: string;
  businessLicense?: string;
  establishedDate?: string;
  companyType?: string;
  address?: string;
  phone?: string;
  [k: string]: any;
}

export interface SavedJob {
  applicantJobId?: string | number;
  applicantId?: string | number;
  jobDescriptionId?: string | number;
  jobTitle?: string;
  companyName?: string;
  location?: string;
  salaryRange?: string;
  [k: string]: any;
}

export interface JobApplicantsCount {
  jobDescriptionId?: string | number;
  applicantCount?: number;
  count?: number;
}

export const getJobId = (j: Job | SavedJob): string => String(j.jobId ?? j.id ?? j.jobDescriptionId ?? "");
export const getJobTitle = (j: Job): string => j.jobTitle ?? j.title ?? "Untitled";

export const fetchHome = () => apiRequest<any>("/api/v1/home", { auth: false });

export const fetchJobs = () =>
  apiRequest<Job[]>("/api/v1/browse-jobs", { auth: false });

export const fetchJob = (id: string | number) =>
  apiRequest<Job>(`/api/v1/browse-jobs/${id}`, { auth: false });

export const fetchJobApplicantCount = (id: string | number) =>
  apiRequest<number | JobApplicantsCount>(`/api/v1/browse-jobs/applicants/${id}`);

export const fetchSavedJobs = (applicantId: string | number) =>
  apiRequest<SavedJob[]>(`/api/v1/applicants/saved-jobs?applicantId=${applicantId}`);

export const saveJob = (applicantId: string | number, jobId: string | number) =>
  apiRequest<unknown>(`/api/v1/applicants/save/job`, {
    method: "POST",
    body: { applicantId, jobDescriptionId: jobId },
  });

export const fetchRecruiterJobs = (recruiterId: string | number) =>
  apiRequest<Job[]>(`/api/v1/recruiters/jobs/${recruiterId}`);

export const createRecruiterJob = (recruiterId: string | number, body: Job) =>
  apiRequest<Job>(`/api/v1/recruiters/jobs/${recruiterId}`, {
    method: "POST",
    body,
  });

export const updateRecruiterJob = (
  recruiterId: string | number,
  jobId: string | number,
  body: Job
) =>
  apiRequest<Job>(`/api/v1/recruiters/jobs/${recruiterId}/${jobId}`, {
    method: "PUT",
    body,
  });

export const fetchApplicants = () => apiRequest<Applicant[]>("/api/v1/applicants");
export const fetchApplicant = (id: string | number) =>
  apiRequest<Applicant>(`/api/v1/applicants/${id}`);
export const updateApplicant = (id: string | number, body: Partial<Applicant>) =>
  apiRequest<Applicant>(`/api/v1/applicants/${id}`, { method: "PUT", body });

export const fetchRecruiters = () => apiRequest<Recruiter[]>("/api/v1/recruiters");
export const fetchRecruiter = (id: string | number) =>
  apiRequest<Recruiter>(`/api/v1/recruiters/${id}`);

export const registerApplicant = (body: any) =>
  apiRequest<any>("/api/v1/registrations/applicant", {
    method: "POST",
    body,
    auth: false,
  });

export const registerRecruiter = (body: any) =>
  apiRequest<any>("/api/v1/registrations/recruiters", {
    method: "POST",
    body,
    auth: false,
  });

export const uploadCv = (applicantId: string | number, body: any) =>
  apiRequest<any>(`/api/v1/applicants/upload-cv/${applicantId}`, {
    method: "POST",
    body,
  });
