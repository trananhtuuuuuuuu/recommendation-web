package DATN.backend.mapper;

import java.sql.Date;
import java.time.LocalDate;

import DATN.backend.model.JobDescription;
import DATN.backend.model.Recruiter;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobDescriptionResponse;

public class JobDescriptionMapper {

    public JobDescription toNewJobDescription(Recruiter recruiter, RecruiterJobRequest request) {
        JobDescription jobDescription = new JobDescription();
        jobDescription.setRecruiter(recruiter);
        jobDescription.setJobTitle(request.getJobTitle());
        jobDescription.setAboutCompany(request.getAboutCompany());
        jobDescription.setJobDescription(request.getJobDescription());
        jobDescription.setRequirements(request.getRequirements());
        jobDescription.setBenefits(request.getBenefits());
        jobDescription.setLocation(request.getLocation());
        jobDescription.setSalaryRange(request.getSalaryRange());
        jobDescription.setJobType(request.getJobType());
        jobDescription.setExperienceLevel(request.getExperienceLevel());
        jobDescription.setIndustry(request.getIndustry());
        jobDescription.setPostedDate(parseDate(request.getPostedDate()));
        jobDescription.setApplicationDeadline(parseDate(request.getApplicationDeadline()));
        jobDescription.setStartDate(parseDate(request.getStartDate()));
        jobDescription.setEndDate(parseDate(request.getEndDate()));
        return jobDescription;
    }

    public JobDescription updateJobDescription(JobDescription jobDescription, RecruiterJobRequest request) {
        jobDescription.setJobTitle(request.getJobTitle());
        jobDescription.setAboutCompany(request.getAboutCompany());
        jobDescription.setJobDescription(request.getJobDescription());
        jobDescription.setRequirements(request.getRequirements());
        jobDescription.setBenefits(request.getBenefits());
        jobDescription.setLocation(request.getLocation());
        jobDescription.setSalaryRange(request.getSalaryRange());
        jobDescription.setJobType(request.getJobType());
        jobDescription.setExperienceLevel(request.getExperienceLevel());
        jobDescription.setIndustry(request.getIndustry());
        jobDescription.setPostedDate(parseDate(request.getPostedDate()));
        jobDescription.setApplicationDeadline(parseDate(request.getApplicationDeadline()));
        jobDescription.setStartDate(parseDate(request.getStartDate()));
        jobDescription.setEndDate(parseDate(request.getEndDate()));
        return jobDescription;
    }

    public JobDescriptionResponse toResponse(JobDescription jobDescription) {
        return new JobDescriptionResponse(
                jobDescription.getId(),
                jobDescription.getJobTitle(),
                jobDescription.getAboutCompany(),
                jobDescription.getJobDescription(),
                jobDescription.getRequirements(),
                jobDescription.getBenefits(),
                jobDescription.getLocation(),
                jobDescription.getSalaryRange(),
                jobDescription.getJobType(),
                jobDescription.getExperienceLevel(),
                jobDescription.getIndustry(),
                jobDescription.getPostedDate() == null ? null : jobDescription.getPostedDate().toString(),
                jobDescription.getApplicationDeadline() == null ? null
                        : jobDescription.getApplicationDeadline().toString(),
                jobDescription.getStartDate() == null ? null : jobDescription.getStartDate().toString(),
                jobDescription.getEndDate() == null ? null : jobDescription.getEndDate().toString(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getId(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getCompanyName());
    }

    public JobApplicantsResponse toApplicantsResponse(Long jobId, Long count) {
        return new JobApplicantsResponse(jobId, count);
    }

    private Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return Date.valueOf(LocalDate.parse(value));
    }
}