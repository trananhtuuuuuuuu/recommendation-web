package DATN.backend.mapper;

import java.sql.Date;
import java.time.LocalDate;

import DATN.backend.model.ApplicationForm;
import DATN.backend.model.Job;
import DATN.backend.model.Recruiter;
import DATN.backend.request.recruiter.RecruiterJobRequest;
import DATN.backend.response.job.JobApplicantsResponse;
import DATN.backend.response.job.JobResponse;
import DATN.backend.utils.StringListConverter;

public class JobMapper {

    private JobMapper() {
    }

    public static Job toNewJob(Recruiter recruiter, RecruiterJobRequest request) {
        Job jobDescription = new Job();
        jobDescription.setRecruiter(recruiter);
        jobDescription.setJobTitle(request.getJobTitle());
        jobDescription.setJobDesc(request.getJobDescription());
        jobDescription.setRequirements(StringListConverter.fromString(request.getRequirements()));
        jobDescription.setBenefits(request.getBenefits());
        jobDescription.setLocation(request.getLocation());
        jobDescription.setSalaryRange(parseSalaryRange(request.getSalaryRange()));
        jobDescription.setJobType(request.getJobType());
        jobDescription.setPostedDate(parseDate(request.getPostedDate()));
        jobDescription.setApplyingDeadline(parseDate(request.getApplyingDeadline()));
        jobDescription.setYoe(request.getYoe());
        jobDescription.setApplicationForm(toApplicationFormReference(request.getCustomApplicationFieldsId()));
        return jobDescription;
    }

    public static Job updateJob(Job jobDescription, RecruiterJobRequest request) {
        jobDescription.setJobTitle(request.getJobTitle());
        jobDescription.setJobDesc(request.getJobDescription());
        jobDescription.setRequirements(StringListConverter.fromString(request.getRequirements()));
        jobDescription.setBenefits(request.getBenefits());
        jobDescription.setLocation(request.getLocation());
        jobDescription.setSalaryRange(parseSalaryRange(request.getSalaryRange()));
        jobDescription.setJobType(request.getJobType());
        jobDescription.setPostedDate(parseDate(request.getPostedDate()));
        jobDescription.setApplyingDeadline(parseDate(request.getApplyingDeadline()));
        jobDescription.setYoe(request.getYoe());
        jobDescription.setApplicationForm(toApplicationFormReference(request.getCustomApplicationFieldsId()));
        return jobDescription;
    }

    public static JobResponse toResponse(Job jobDescription) {
        return new JobResponse(
                jobDescription.getId(),
                jobDescription.getJobTitle(),
                jobDescription.getJobDesc(),
                StringListConverter.join(jobDescription.getRequirements()),
                jobDescription.getBenefits(),
                jobDescription.getLocation(),
                jobDescription.getSalaryRange() == null ? null : jobDescription.getSalaryRange().toString(),
                jobDescription.getJobType(),
                jobDescription.getPostedDate() == null ? null : jobDescription.getPostedDate().toString(),
                jobDescription.getApplyingDeadline() == null ? null
                        : jobDescription.getApplyingDeadline().toString(),
                jobDescription.getYoe(),
                jobDescription.getApplicationForm() == null ? null : jobDescription.getApplicationForm().getId(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getId(),
                jobDescription.getRecruiter() == null ? null : jobDescription.getRecruiter().getCompanyName());
    }

    public static JobApplicantsResponse toApplicantsResponse(Long jobId, Long count) {
        return new JobApplicantsResponse(jobId, count);
    }

    private static Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return Date.valueOf(LocalDate.parse(value));
    }

    private static Double parseSalaryRange(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Double.valueOf(value);
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private static ApplicationForm toApplicationFormReference(Long id) {
        if (id == null) {
            return null;
        }
        ApplicationForm applicationForm = new ApplicationForm();
        applicationForm.setId(id);
        return applicationForm;
    }
}
