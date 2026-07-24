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
  benefits?: string | string[];
  location?: string;
  salaryRange?: string;
  jobType?: string;
  yoe?: string;
  experienceLevel?: string;
  industry?: string;
  postedDate?: string;
  applyingDeadline?: string;
  applicationDeadline?: string;
  startDate?: string;
  endDate?: string;
  companyName?: string;
  recruiterId?: string | number;
  recruiterName?: string;
  customApplicationFieldsId?: number;
  customApplicationFields?: string;
  [k: string]: unknown;
}

export interface RecruiterJobPayload {
  jobTitle?: string;
  aboutCompany?: string;
  jobDescription?: string;
  requirements?: string;
  benefits?: string[];
  location?: string;
  salaryRange?: string;
  jobType?: string;
  postedDate?: string;
  applyingDeadline?: string;
  yoe?: string;
  customApplicationFieldsId?: number;
  experienceLevel?: string;
  industry?: string;
  startDate?: string;
  endDate?: string;
  customApplicationFields?: string;
}

export interface CvExperience {
  id?: string | number;
  companyName?: string;
  jobTitle?: string;
  field?: string;
  contribution?: string;
  startDate?: string;
  endDate?: string;
  isPresent?: boolean;
}

export interface CvEducation {
  id?: string | number;
  name?: string;
  major?: string;
  degree?: string;
  startDate?: string;
  endDate?: string;
}

export interface CvCertificate {
  id?: string | number;
  name?: string;
  score?: string;
  provider?: string;
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
  cv?: {
    id?: string | number;
    fullName?: string;
    address?: string;
    phone?: string;
    objective?: string;
    skills?: string | string[];
    experience?: string | CvExperience | null;
    education?: string | CvEducation | null;
    certifications?: string | CvCertificate | null;
    cvFileUrl?: string;
  } | null;
  [k: string]: unknown;
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
  coverImageUrl?: string;
  contactEmail?: string;
  contactPhone?: string;
  taxCode?: string;
  businessLicense?: string;
  establishedDate?: string;
  companyType?: string;
  address?: string;
  phone?: string;
  [k: string]: unknown;
}

export interface SavedJob {
  applicantJobId?: string | number;
  applicantId?: string | number;
  jobDescriptionId?: string | number;
  jobTitle?: string;
  companyName?: string;
  location?: string;
  salaryRange?: string;
  jobType?: string;
  status?: string;
  savedAt?: string;
  appliedAt?: string;
  [k: string]: unknown;
}

export interface PageResponse<T> {
  content: T[];
  page: number;
  size: number;
  totalElements: number;
  totalPages: number;
  first: boolean;
  last: boolean;
}

export interface HomeSummary {
  jobsPosted?: number;
  recruiters?: number;
  activeApplicants?: number;
}

export interface JobApplicantsCount {
  jobDescriptionId?: string | number;
  applicantCount?: number;
  count?: number;
}

export interface ApplicantActivityCount {
  jobId: string | number;
  approximateApplicantCount: number;
  displayText: string;
  approximate: boolean;
}

export interface AnonymousCandidatePreviewProfile {
  anonymousProfileId: string;
  experienceLevel?: string;
  skillCategories?: string[];
  educationLevel?: string;
  generalRegion?: string;
  currentRoleCategory?: string;
}

export interface AnonymousCandidatePreviews {
  available: boolean;
  message?: string;
  profiles: AnonymousCandidatePreviewProfile[];
}

export interface JobApplicant {
  applicationId?: string | number;
  applicationOrder?: number;
  jobDescriptionId?: string | number;
  applicant?: Applicant;
  coverLetter?: string;
  portfolioUrl?: string;
  applicationAnswers?: string;
}

export interface RecruiterApplicantMatch {
  applicationId: string | number;
  applicationOrder: number;
  applicant: Applicant;
  match: CvJobMatch;
}

export interface ApplicationField {
  id: string;
  label: string;
  type: "text" | "select" | "textarea" | "url";
  required?: boolean;
  options?: string[];
}

export interface CvExperienceSuggestion {
  companyName?: string;
  position?: string;
  time?: string;
  description?: string;
  skills?: string | string[];
  certificates?: string;
}

export interface CvAnalysis {
  fullName?: string;
  detectedEmail?: string;
  phone?: string;
  address?: string;
  objective?: string;
  skills?: string[];
  experience?: CvExperienceSuggestion[];
  education?: string[];
  certifications?: string[];
  extractionMode?: "layoutlmv3" | "heuristic" | string;
  confidence?: number | null;
  warnings?: string[];
}

export const getJobId = (j: Job | SavedJob): string => String(j.jobId ?? j.id ?? j.jobDescriptionId ?? "");
export const getJobTitle = (j: Job): string => j.jobTitle ?? j.title ?? "Untitled";
export const getApplyingDeadline = (j: Job): string | undefined => j.applyingDeadline ?? j.applicationDeadline;

const normalizeJob = (job: Job): Job => ({
  ...job,
  benefits: Array.isArray(job.benefits) ? job.benefits.join("\n") : job.benefits,
  applicationDeadline: job.applicationDeadline ?? job.applyingDeadline,
  applyingDeadline: job.applyingDeadline ?? job.applicationDeadline,
});

const normalizeJobs = (jobs: Job[]): Job[] => jobs.map(normalizeJob);

const normalizeJobPage = (page: PageResponse<Job>): PageResponse<Job> => ({
  ...page,
  content: normalizeJobs(page.content),
});

const toPageParams = (page = 0, size = 5, sort = "id,desc") =>
  new URLSearchParams({
    page: String(page),
    size: String(size),
    sort,
  }).toString();

const cleanString = (value: unknown): string | undefined => {
  if (typeof value !== "string") return undefined;
  const trimmed = value.trim();
  return trimmed ? trimmed : undefined;
};

const toTextList = (value: Job["benefits"]): string[] | undefined => {
  const values = Array.isArray(value) ? value : value?.split(/[\n,;|]/);
  const normalized = values?.map((item) => item.trim()).filter(Boolean) ?? [];
  return normalized.length > 0 ? normalized : undefined;
};

export const toRecruiterJobPayload = (job: Job): RecruiterJobPayload => ({
  jobTitle: cleanString(job.jobTitle),
  aboutCompany: cleanString(job.aboutCompany),
  jobDescription: cleanString(job.jobDescription ?? job.description),
  requirements: cleanString(job.requirements),
  benefits: toTextList(job.benefits),
  location: cleanString(job.location),
  salaryRange: cleanString(job.salaryRange),
  jobType: cleanString(job.jobType),
  postedDate: cleanString(job.postedDate),
  applyingDeadline: cleanString(job.applyingDeadline ?? job.applicationDeadline),
  yoe: cleanString(job.yoe),
  customApplicationFieldsId: typeof job.customApplicationFieldsId === "number" ? job.customApplicationFieldsId : undefined,
  experienceLevel: cleanString(job.experienceLevel),
  industry: cleanString(job.industry),
  startDate: cleanString(job.startDate),
  endDate: cleanString(job.endDate),
  customApplicationFields: cleanString(job.customApplicationFields),
});

export const fetchHome = () => apiRequest<HomeSummary>("/api/v1/home", { auth: false });

export const fetchJobsPage = (page = 0, size = 10, sort = "id,desc") =>
  apiRequest<PageResponse<Job>>(`/api/v1/browse-jobs?${toPageParams(page, size, sort)}`, { auth: false })
    .then(normalizeJobPage);

export const fetchJobs = () =>
  apiRequest<Job[] | PageResponse<Job>>("/api/v1/browse-jobs", { auth: false }).then((data) =>
    Array.isArray(data) ? normalizeJobs(data) : normalizeJobs(data.content),
  );

export const fetchJob = (id: string | number) =>
  apiRequest<Job>(`/api/v1/browse-jobs/${id}`, { auth: false }).then(normalizeJob);

export const fetchJobApplicantCount = (id: string | number) =>
  apiRequest<number | JobApplicantsCount>(`/api/v1/browse-jobs/applicants/${id}`);

export const fetchApplicantActivityCount = (id: string | number) =>
  apiRequest<ApplicantActivityCount>(`/api/v1/jobs/${id}/applicant-count`);

export const fetchAnonymousCandidatePreviews = (id: string | number) =>
  apiRequest<AnonymousCandidatePreviews>(`/api/v1/jobs/${id}/anonymous-candidate-previews`);

export const fetchJobApplicants = (jobId: string | number, recruiterId?: string | number) =>
  recruiterId
    ? apiRequest<JobApplicant[]>(`/api/v1/recruiters/jobs/${recruiterId}/${jobId}/applicants`)
    : apiRequest<JobApplicant[]>(`/api/v1/browse-jobs/applicants/${jobId}/list`);

export const matchRecruiterApplicants = (
  recruiterId: string | number,
  jobId: string | number,
  options: { llm?: boolean; method?: string } = {},
) => apiRequest<RecruiterApplicantMatch[]>(
  `/api/v1/recruiters/jobs/${recruiterId}/${jobId}/ai-match`,
  { method: "POST", body: options },
);

export const matchRecruiterApplicant = (
  recruiterId: string | number,
  jobId: string | number,
  applicantId: string | number,
  options: { llm?: boolean; method?: string } = {},
) => apiRequest<RecruiterApplicantMatch>(
  `/api/v1/recruiters/jobs/${recruiterId}/${jobId}/applicants/${applicantId}/ai-match`,
  { method: "POST", body: options },
);

export const fetchSavedJobs = (applicantId: string | number, page = 0, size = 5, sort = "id,desc") =>
  apiRequest<PageResponse<SavedJob>>(
    `/api/v1/applicants/saved-jobs?applicantId=${applicantId}&${toPageParams(page, size, sort)}`,
  );

export const saveJob = (applicantId: string | number, jobId: string | number) =>
  apiRequest<unknown>(`/api/v1/applicants/save/job`, {
    method: "POST",
    body: { applicantId, jobDescriptionId: jobId },
  });

export const applyJob = (applicantId: string | number, jobId: string | number, body: Record<string, unknown> = {}) =>
  apiRequest<unknown>(`/api/v1/applicants/apply/job`, {
    method: "POST",
    body: { applicantId, jobDescriptionId: jobId, ...body },
  });

export const fetchAppliedJobs = (applicantId: string | number, page = 0, size = 5, sort = "id,desc") =>
  apiRequest<PageResponse<SavedJob>>(
    `/api/v1/applicants/applied-jobs?applicantId=${applicantId}&${toPageParams(page, size, sort)}`,
  );

export const removeSavedJob = (applicantId: string | number, applicantJobId: string | number) =>
  apiRequest<SavedJob>(`/api/v1/applicants/${applicantId}/saved-jobs/${applicantJobId}`, {
    method: "DELETE",
  });

export const withdrawApplication = (applicantId: string | number, applicantJobId: string | number) =>
  apiRequest<SavedJob>(`/api/v1/applicants/${applicantId}/applied-jobs/${applicantJobId}`, {
    method: "DELETE",
  });

export const fetchRecruiterJobs = (recruiterId: string | number) =>
  apiRequest<Job[]>(`/api/v1/recruiters/jobs/${recruiterId}`).then(normalizeJobs);

export const uploadRecruiterImage = (
  recruiterId: string | number,
  imageType: "logo" | "cover",
  image: File,
) => {
  const formData = new FormData();
  formData.append("image", image);
  return apiRequest<Recruiter>(`/api/v1/recruiters/${recruiterId}/images/${imageType}`, {
    method: "POST",
    body: formData,
    isForm: true,
  });
};

export const createRecruiterJob = (recruiterId: string | number, body: Job) =>
  apiRequest<Job>(`/api/v1/recruiters/jobs/${recruiterId}`, {
    method: "POST",
    body: toRecruiterJobPayload(body),
  }).then(normalizeJob);

export const updateRecruiterJob = (
  recruiterId: string | number,
  jobId: string | number,
  body: Job
) =>
  apiRequest<Job>(`/api/v1/recruiters/jobs/${recruiterId}/${jobId}`, {
    method: "PUT",
    body: toRecruiterJobPayload(body),
  }).then(normalizeJob);

export const fetchApplicants = () => apiRequest<Applicant[]>("/api/v1/applicants");
export const fetchApplicant = (id: string | number) =>
  apiRequest<Applicant>(`/api/v1/applicants/${id}`);
export const updateApplicant = (id: string | number, body: Partial<Applicant>) =>
  apiRequest<Applicant>(`/api/v1/applicants/${id}`, { method: "PUT", body });

export const fetchRecruiters = () => apiRequest<Recruiter[]>("/api/v1/recruiters");
export const fetchRecruiter = (id: string | number) =>
  apiRequest<Recruiter>(`/api/v1/recruiters/${id}`);
export const updateRecruiter = (id: string | number, body: Partial<Recruiter>) =>
  apiRequest<Recruiter>(`/api/v1/recruiters/${id}`, { method: "PUT", body });

export const registerApplicant = (body: Record<string, unknown>) =>
  apiRequest<unknown>("/api/v1/registrations/applicant", {
    method: "POST",
    body,
    auth: false,
  });

export const registerRecruiter = (body: Record<string, unknown>) =>
  apiRequest<unknown>("/api/v1/registrations/recruiters", {
    method: "POST",
    body,
    auth: false,
  });

export const uploadCv = (applicantId: string | number, body: FormData | Record<string, unknown>) =>
  apiRequest<unknown>(`/api/v1/applicants/upload-cv/${applicantId}`, {
    method: "POST",
    body,
    isForm: body instanceof FormData,
  });

export const deleteUploadedCvFile = (applicantId: string | number) =>
  apiRequest<Applicant["cv"]>(`/api/v1/applicants/${applicantId}/cv-file`, {
    method: "DELETE",
  });

export const analyzeCv = (applicantId: string | number, cvFile: File) => {
  const body = new FormData();
  body.append("cvFile", cvFile);
  return apiRequest<CvAnalysis>(`/api/v1/applicants/${applicantId}/analyze-cv`, {
    method: "POST",
    body,
    isForm: true,
  });
};

export interface CvJobMatch {
  applicantId?: string | number;
  jobId?: string | number;
  passedFilter?: boolean;
  matchScore?: number;
  matchPercent?: number;
  reason?: string;
  suggestions?: string[];
  perFieldScores?: Record<string, number>;
  hardFilterReasons?: string[];
  scoringMethod?: string;
  modelUsed?: string;
  differentialPrivacyApplied?: boolean;
  privacyEpsilon?: number;
  scoreSensitivity?: number;
  privacyMechanism?: string;
}

export const AI_MATCH_OPTIONS = { llm: true, method: "tfidf" } as const;
export const AI_SCORE_OPTIONS = { llm: false, method: "tfidf" } as const;

export const matchCvToJob = (
  applicantId: string | number,
  jobId: string | number,
  options: { llm?: boolean; method?: string } = {},
) =>
  apiRequest<CvJobMatch>(`/api/v1/applicants/${applicantId}/match/${jobId}`, {
    method: "POST",
    body: options,
  });
