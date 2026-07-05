# Differential Privacy Implementation Plan And Theory

This document is a compact bridge between beginner theory and engineering decisions.

## What The Formula Means

Differential privacy definition:

```text
Pr[M(D) in S] <= exp(epsilon) * Pr[M(D') in S]
```

Symbols:

- `D`: original dataset, for example 20 applicants;
- `D'`: neighboring dataset, for example the same data with one applicant removed, so 19 applicants;
- `M`: mechanism, meaning the algorithm that produces the published answer;
- `S`: a set of possible outputs, for example "outputs between 17 and 20";
- `Pr`: probability, meaning chance;
- `epsilon`: selected privacy setting;
- `exp(epsilon)`: `e` raised to epsilon.

Ordinary-language guarantee:

The result should not become much more likely just because one specific person is included.

## Laplace Alternative

The continuous Laplace mechanism uses:

```text
b = Delta f / epsilon
```

Symbols:

- `b`: scale, controlling how wide the noise is;
- `Delta f`: sensitivity;
- `epsilon`: privacy setting.

For this count:

```text
Delta f = 1
epsilon = 0.5
b = 1 / 0.5
b = 2
```

Then:

```text
Z ~ Laplace(0, 2)
```

Symbols:

- `Z`: random noise;
- `~`: "is sampled from";
- `Laplace(0, 2)`: Laplace distribution centered at 0 with scale 2.

Density:

```text
f(z) = 1 / (2b) * exp(-abs(z) / b)
```

For `b = 2`:

```text
f(z) = 1 / 4 * exp(-abs(z) / 2)
```

This project uses an integer-valued mechanism because the output is a count.

## Implementation Plan

1. Keep raw count query inside backend.
2. Count `COUNT(DISTINCT applicant_id)`.
3. Filter to valid `APPLIED` rows.
4. Validate epsilon.
5. Build release key from job, metric, audience, and window.
6. Check persistent release store.
7. If missing, derive deterministic HMAC randomness.
8. Sample integer noise.
9. Clamp to zero.
10. Persist released value only.
11. Return safe DTO.
12. Render approximate label in React.

## Why Not Frontend Noise

React runs on the user's device.

If the backend sends raw count to React, the raw count is already exposed.

Therefore noise must be generated in the trusted backend.

## Why Not Exact Fallback

If the privacy service fails, returning the exact count would create a bypass.

Correct fallback:

```text
Return error or unavailable state.
```

Wrong fallback:

```text
Return raw count.
```

