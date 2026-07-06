# Differential Privacy And Anonymous Candidate Preview

## Part A: Differentially Private Aggregate Count

The applicant-facing applicant activity count is an aggregate query only. It counts distinct applicants with genuine submitted applications for a job:

`COUNT(DISTINCT applicant_id)` where `action_type = 'APPLIED'`, excluding saved jobs, bookmarks, withdrawn applications, cancelled applications, deleted applications, and duplicate application records.

Differential privacy is used only for this aggregate count. Individual applicant profiles are not treated as differential privacy outputs.

For this count query, global sensitivity is:

`Delta f = 1`

Epsilon is selected by the system owner as a privacy parameter. It is not calculated from the raw count, it is not an error percentage, and it is not the number of candidates added or removed. Smaller epsilon provides stronger privacy and more noise. Larger epsilon provides weaker privacy and less noise.

Laplace mechanism:

`b = Delta f / epsilon`

For this count:

`b = 1 / epsilon`

Laplace density:

`f(z) = 1 / (2b) * exp(-abs(z) / b)`

Released value:

`max(0, round(rawCount + z))`

The implementation uses the integer-only discrete Laplace/two-sided geometric alternative:

`q = exp(-epsilon)`

`P(Z = k) = ((1 - q) / (1 + q)) * q^abs(k)`

Released value:

`max(0, rawCount + Z)`

Releases are sticky for the same job ID, metric name, audience, and release window. The release key shape is:

`JOB_APPLICANT_COUNT|jobId=123|audience=APPLICANT|window=epoch-window-N`

HMAC-SHA-256 with `DP_RELEASE_SECRET` derives deterministic randomness. Sticky released values are persisted in PostgreSQL in `privacy_releases`, so they survive restarts and work across backend instances. Applicant-facing responses never serialize the raw count, epsilon internals, HMAC digest, random seed, generated noise, or secret.

Operational configuration:

```yaml
privacy:
  differential:
    enabled: true
    applicant-count:
      epsilon: 0.5
      release-window: P7D
      release-secret: ${DP_RELEASE_SECRET}
```

## Part B: Consent-Based Anonymous Candidate Preview

The anonymous candidate preview is not differential privacy. It is consent-based, access-controlled, data-minimized profile sharing.

Differential privacy protects aggregate queries. It does not make one real applicant profile anonymous. Adding random noise to one applicant profile would not make that profile differentially private.

Consent is separate from recruiter visibility. Candidates appear only when `profile_visible_to_other_applicants = true`, which defaults to false. Recruiter visibility alone does not imply applicant-to-applicant visibility.

Allowed fields are broad and non-identifying:

- broad experience bucket
- approved broad skill categories
- education level
- broad geographic region
- broad current-role category

Prohibited fields include database applicant ID, user ID, full name, username, email, phone number, exact address, date of birth, gender, CV URL, profile image, exact company name, exact university name, exact employment dates, exact application timestamp, certificate serial number, social media URL, portfolio URL, unique biography, and internal identifiers.

Skills are mapped into approved categories such as Backend, Frontend, Database, Cloud, DevOps, Data, Machine Learning, Mobile, Quality Assurance, and Product Design. Raw free-text skill values are not returned.

Anonymous identifiers are opaque HMAC-derived tokens scoped to viewer, job, candidate, and rotation window. They cannot be used to correlate the same candidate across jobs or long periods.

Access requires:

- authenticated applicant role
- viewer has applied to the same job
- target candidate has applied and has not withdrawn
- target candidate opted in to applicant visibility
- job exists
- feature is enabled

Users who merely saved the job cannot access previews. Callers cannot choose candidate IDs; the backend selects a small deterministic sample within the rotation window.

Small-group suppression prevents previews unless the eligible opted-in group meets the configured threshold. The response does not expose the exact eligible count.

Operational configuration:

```yaml
privacy:
  anonymous-candidate-preview:
    enabled: true
    minimum-eligible-candidates: 10
    maximum-previews: 3
    rotation-window: P7D
    rate-limit-per-window: 20
    token-secret: ${ANON_PREVIEW_TOKEN_SECRET}
```

Limitations and re-identification risks remain: broad categories reduce direct identifiers but cannot guarantee anonymity if a viewer combines the preview with external knowledge. Keep thresholds conservative, avoid rare categories, rotate identifiers, and monitor access patterns.

Test strategy covers distinct aggregate semantics, saved/withdrawn exclusions, epsilon validation/noise behavior, clamping, sticky releases, response minimization, consent separation, same-job access control, saved-job denial, small-group suppression, field prohibitions, broad skill mapping, scoped/rotating anonymous IDs, no unrestricted pagination, rate limiting, and withdrawn applicant exclusion.
