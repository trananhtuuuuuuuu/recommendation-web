# Differential Privacy Testing Guide

This guide explains what to test and why.

## How To Run Tests

Backend:

```bash
cd backend
./mvnw test
```

Focused backend privacy test:

```bash
cd backend
./mvnw -Dtest=DATN.backend.BackendEndpointsIntegrationTests#applicantFacingCountShouldBeDifferentiallyPrivateStickyAndDistinct test
```

Frontend build:

```bash
cd frontend
npm run build
```

Frontend tests:

```bash
cd frontend
npm run test
```

## 1. Count Query Tests

### Test: distinct genuine applications are counted

Why:

The privacy math assumes one applicant changes the count by at most one.

If duplicate rows count multiple times, sensitivity is wrong.

### Test: saved jobs are excluded

Why:

Saving a job is not applying.

Including saved jobs would produce the wrong raw count.

### Test: withdrawn applications are excluded

Why:

A withdrawn candidate should not count as actively applied.

### Test: deleted records are excluded

Why:

Deleted application, applicant, or job records should not affect the live count.

## 2. Noise Generator Tests

### Test: epsilon must be greater than zero

Why:

The formula needs positive epsilon. Zero or negative epsilon is invalid.

### Test: smaller epsilon gives more spread

Why:

Smaller epsilon means stronger privacy and more noise.

### Test: larger epsilon gives less spread

Why:

Larger epsilon means weaker privacy and less noise.

### Statistical caution

One random output does not prove a distribution is correct.

For development, sample many outputs and check broad behavior.

Avoid fragile CI tests with strict random thresholds.

The current production path uses deterministic HMAC-derived bytes, so sticky release tests can be deterministic.

## 3. Sticky Release Tests

### Test: same job and release window returns same value

Why:

Fresh noise on each refresh can be averaged toward the exact count.

### Test: multiple applicants see the same release

Why:

The release key uses job, metric, audience, and window. It should not depend on viewer identity for the aggregate count.

### Test: release is persisted

Why:

The same value should survive backend restarts and work across backend instances using the same PostgreSQL database.

## 4. Security Tests

### Test: applicant role is required

Why:

The endpoint is applicant-facing.

### Test: raw count and noise are not serialized

Why:

Returning raw count or noise defeats the purpose.

### Test: exact fallback is forbidden

Why:

If privacy logic fails, the API must not return the raw count.

## 5. Controller Tests

### Test: safe DTO shape

Expected fields:

- `jobId`;
- `approximateApplicantCount`;
- `displayText`;
- `approximate`.

Forbidden fields:

- `rawCount`;
- `noise`;
- `secret`;
- `seed`;
- `epsilonCalculation`.

## 6. Frontend Tests

### Test: applicant sees approximate label

Why:

The UI must not imply exactness.

Expected text:

```text
Approximately N candidates have applied
```

and:

```text
This count is intentionally approximate to protect applicant privacy.
```

### Test: loading, error, and retry states exist

Why:

The UI should not silently hide applicant activity when a request fails.

### Test: frontend does not call exact count endpoint for applicants

Why:

Applicants should not receive exact counts.

## 7. Anonymous Preview Tests

### Test: only opted-in candidates are eligible

Why:

Applicant-to-applicant visibility requires separate consent.

### Test: recruiter visibility alone does not count

Why:

Recruiter visibility and applicant visibility are different permissions.

### Test: saved-job users cannot access previews

Why:

Preview access requires applying to the same job.

### Test: small groups are suppressed

Why:

Small groups are easier to re-identify.

### Test: no direct identifiers are serialized

Forbidden:

- applicant ID;
- user ID;
- name;
- email;
- phone;
- address;
- CV URL;
- exact company;
- exact university.

## Current Test Coverage In This Repo

`BackendEndpointsIntegrationTests` includes privacy assertions for:

- distinct count semantics;
- saved and withdrawn exclusion;
- sticky releases;
- multiple applicants seeing the same release;
- response not exposing raw count or noise;
- opt-in anonymous previews;
- saved-only users denied for previews;
- small group suppression;
- broad skill categories;
- scoped anonymous IDs;
- rate limiting.

