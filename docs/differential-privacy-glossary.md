# Differential Privacy Glossary

Simple definitions for this project.

## Aggregate

A combined result about many people.

Example:

```text
Total number of applicants for job 123.
```

## Anonymization

Changing or removing direct identifiers like names and emails.

Important: anonymization does not guarantee that a person cannot be re-identified.

## Approximate Count

A count that is close to the real count but not exact.

Example:

```text
Approximately 18 candidates have applied.
```

## Composition

The idea that privacy loss can add up across multiple releases.

Example:

```text
4 releases * epsilon 0.5 = total epsilon 2.0
```

## Data Minimization

Sharing only the smallest amount of data needed.

Example:

Share `Backend`, not a full rare skill list.

## Deterministic Randomness

Random-looking output that repeats for the same input.

Example:

Job 123 in the same week gets the same noisy count.

## Differential Privacy

A privacy method that makes an aggregate result look reasonably similar whether one person's data is included or not.

## Epsilon

A selected privacy setting.

Smaller epsilon means stronger privacy and usually more noise.

Larger epsilon means weaker privacy and usually less noise.

It is not a percentage and not the number of applicants hidden.

## Geometric Random Variable

A random whole number where small values are more likely than large values.

It can be used to build integer noise.

## HMAC

A secure keyed hash.

Beginner version:

```text
input + secret key -> random-looking output
```

The secret key must stay on the backend.

## Laplace Distribution

A probability distribution where values near zero are more likely and far-away values are less likely.

It is often used to add noise for differential privacy.

## Neighboring Datasets

Two datasets that differ by one person's data.

Example:

```text
D: 20 applicants
D': 19 applicants
```

## Noise

A random number added to a real result.

Example:

```text
raw count 20 + noise -2 = displayed count 18
```

## Post-Processing

Changing the noisy result without using private raw data again.

Example:

```text
max(0, noisyCount)
```

## Probability Distribution

A rule describing which random values are more likely.

Example:

Noise `0` is usually more likely than noise `10`.

## Privacy Budget

A limit on total privacy loss over time.

It helps control repeated releases.

## Probability Density

For continuous distributions, density describes where values are more concentrated.

You do not need density for the integer mechanism used here, but the continuous Laplace density is:

```text
f(z) = 1 / (2b) * exp(-abs(z) / b)
```

`b` is the scale. Bigger `b` means wider noise.

## Re-Identification

Figuring out who an anonymous person is by combining indirect information with outside knowledge.

## Release Window

A time period where the same privacy-protected value is reused.

Example:

```text
P7D = 7 days
```

## Sensitivity

The largest possible change in the raw answer when one person's data is added or removed.

For this applicant count:

```text
Delta f = 1
```

## Sticky Noise

Noise that stays the same for the same job, metric, audience, and release window.

This prevents users from averaging many refreshes.

## Threat Model

A description of what an attacker may know and try.

Example:

An applicant knows their friend might apply and watches the count.

