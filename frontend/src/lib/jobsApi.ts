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
  [k: string]: any;
}

export const getJobId = (j: Job): string => String(j.jobId ?? j.id ?? "");
export const getJobTitle = (j: Job): string => j.jobTitle ?? j.title ?? "Untitled";

export const fetchHome = () => apiRequest<any>("/api/v1/home", { auth: false });

export const fetchJobs = () =>
  apiRequest<Job[]>("/api/v1/browse-jobs", { auth: false });

export const fetchJob = (id: string | number) =>
  apiRequest<Job>(`/api/v1/browse-jobs/${id}`, { auth: false });

export const fetchJobApplicantCount = (id: string | number) =>
  apiRequest<number | { count: number }>(`/api/v1/browse-jobs/applicants/${id}`);

export const fetchSavedJobs = (applicantId: string | number) =>
  apiRequest<Job[]>(`/api/v1/applicants/saved-jobs?applicantId=${applicantId}`);

export const saveJob = (applicantId: string | number, jobId: string | number) =>
  apiRequest<unknown>(`/api/v1/applicants/save/job`, {
    method: "POST",
    body: { applicantId, jobId },
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

export const fetchApplicants = () => apiRequest<any[]>("/api/v1/applicants");
export const fetchApplicant = (id: string | number) =>
  apiRequest<any>(`/api/v1/applicants/${id}`);
export const updateApplicant = (id: string | number, body: any) =>
  apiRequest<any>(`/api/v1/applicants/${id}`, { method: "PUT", body });

export const fetchRecruiters = () => apiRequest<any[]>("/api/v1/recruiters");
export const fetchRecruiter = (id: string | number) =>
  apiRequest<any>(`/api/v1/recruiters/${id}`);

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
