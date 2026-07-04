# Privacy References For Graduation Report

This file collects report-ready references for three privacy approaches in the recommendation/recruitment website:

1. Consent and visibility control: candidates choose which profile fields are visible to recruiters.
2. k-anonymity: candidate shortlists generalize quasi-identifiers so each candidate is hidden among at least `k - 1` similar candidates.
3. Differential privacy: noisy match scores reduce the risk that recruiters infer sensitive candidate attributes by repeatedly querying similar job descriptions.

Accessed: 2026-07-04.

## 1. Consent And Visibility Control

### Core idea for this project

Candidates should be able to control profile visibility at field level, for example:

- Public fields: name or display name, general skills, high-level experience.
- Recruiter-visible fields: CV file, phone number, email, detailed education, certificates.
- Hidden fields: sensitive attributes, exact address, private CV sections.

This maps well to GDPR-style principles because it supports transparency, user control, consent withdrawal, data minimization, and privacy by default.

### Recommended report references

[1] European Parliament and Council of the European Union, "Regulation (EU) 2016/679 ... General Data Protection Regulation," Official Journal of the European Union, 2016. Available: https://eur-lex.europa.eu/eli/reg/2016/679/oj

- Use for: legal motivation, lawful processing, data subject rights, transparency, consent, and privacy by design.
- Useful parts:
  - Recital 7: natural persons should have control of their own personal data.
  - Article 7: conditions for consent and right to withdraw consent.
  - Articles 12-23: rights of the data subject.
  - Article 25: data protection by design and by default.

[2] European Data Protection Board, "Guidelines 05/2020 on consent under Regulation 2016/679," 2020. Available: https://www.edpb.europa.eu/documents/guideline/guidelines-052020-on-consent-under-regulation-2016679_en

- Use for: explaining what valid consent means in a user-facing system.
- Project mapping: visibility toggles should be specific, understandable, reversible, and not bundled into a single vague permission.

[3] Information Commissioner's Office, "Guide to the UK GDPR: Individual rights." Available: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/individual-rights/

- Use for: practical explanation of access, rectification, erasure, restriction, portability, and objection rights.
- Project mapping: candidates can inspect their profile data, update it, delete uploaded CV files, and choose what recruiters can view.

### Suggested paragraph for the report

The system applies consent and visibility control as a user-facing privacy mechanism. Instead of treating the applicant profile as a single public object, the candidate can control the visibility of profile sections such as contact information, CV file, education, certificates, and experience. This implements the GDPR principle that natural persons should have control over their personal data and supports privacy-by-default because fields can remain hidden unless the candidate explicitly enables recruiter visibility.

## 2. k-Anonymity For Recruiter Shortlists

### Core idea for this project

Before recruiters see a shortlist, the system can generalize quasi-identifiers so a candidate is not unique in the displayed result set.

Candidate quasi-identifiers may include:

- Exact age or graduation year.
- Exact address or district.
- University name if rare in the shortlist.
- Very specific job title or rare skill combination.
- Years of experience.

Generalization examples:

- Exact age `23` -> age range `20-25`.
- Exact address `District 5, Ho Chi Minh City` -> `Ho Chi Minh City`.
- `3.5 years Java Spring Boot` -> `3-5 years backend experience`.
- Rare school or certificate -> generalized education/certification category.

The shortlist should only expose quasi-identifier combinations that appear at least `k` times. If not enough candidates are available, the system can either generalize more fields, suppress some fields, or hide the shortlist until the group is large enough.

### Recommended report references

[4] L. Sweeney, "k-anonymity: A model for protecting privacy," International Journal of Uncertainty, Fuzziness and Knowledge-Based Systems, vol. 10, no. 5, pp. 557-570, 2002. DOI: https://doi.org/10.1142/S0218488502001648

- Use for: the central definition of k-anonymity.
- Project mapping: a recruiter shortlist is safe to display only when each visible quasi-identifier pattern appears in at least `k` candidate records.

[5] P. Samarati, "Protecting respondents' identities in microdata release," IEEE Transactions on Knowledge and Data Engineering, vol. 13, no. 6, pp. 1010-1027, 2001. DOI: https://doi.org/10.1109/69.971193

- Use for: generalization and suppression as practical anonymization operations.
- Project mapping: exact candidate fields can be generalized or suppressed before recruiter display.

[6] P. Samarati and L. Sweeney, "Protecting privacy when disclosing information: k-anonymity and its enforcement through generalization and suppression," SRI International Technical Report, 1998. Available: https://dataprivacylab.org/dataprivacy/projects/kanonymity/paper3.pdf

- Use for: original enforcement strategy using generalization and suppression.
- Project mapping: implement generalization hierarchies for location, experience, education, and skills.

[7] A. Machanavajjhala, D. Kifer, J. Gehrke, and M. Venkitasubramaniam, "l-diversity: Privacy beyond k-anonymity," ACM Transactions on Knowledge Discovery from Data, vol. 1, no. 1, 2007. DOI: https://doi.org/10.1145/1217299.1217302

- Use for: limitations of plain k-anonymity, especially homogeneity and background knowledge attacks.
- Project mapping: if every candidate in a k-anonymous group has the same sensitive value, k-anonymity may still leak information. This can be discussed as future work.

[8] N. Li, T. Li, and S. Venkatasubramanian, "t-closeness: Privacy beyond k-anonymity and l-diversity," IEEE ICDE, 2007. DOI: https://doi.org/10.1109/ICDE.2007.367856

- Use for: stronger protection against attribute disclosure by comparing group distributions with the whole dataset distribution.
- Project mapping: useful future improvement if the shortlist exposes sensitive distributions such as salary expectation, gender, or rare certifications.

[9] D. Slijepcevic, M. Henzl, L. D. Klausner, T. Dam, P. Kieseberg, and M. Zeppelzauer, "k-Anonymity in practice: How generalisation and suppression affect machine learning classifiers," Computers & Security, 2021. Preprint: https://arxiv.org/abs/2102.04763

- Use for: privacy-utility tradeoff in ML pipelines.
- Project mapping: stronger anonymization may reduce ranking quality, so the report can discuss the tradeoff between privacy and recruiter usefulness.

### Suggested paragraph for the report

The recruiter shortlist applies k-anonymity to reduce re-identification risk. Direct identifiers such as applicant name, phone number, and email are removed unless the candidate has consented to disclosure. Quasi-identifiers such as location, education, experience level, and rare skills are generalized until every visible quasi-identifier tuple appears in at least `k` candidates. This prevents a recruiter from singling out one candidate based on a unique combination of profile attributes. Because k-anonymity can still be vulnerable to homogeneity and background knowledge attacks, the system can later be extended with l-diversity or t-closeness.

## 3. Differential Privacy For Match Scores

### Core idea for this project

When a recruiter receives a candidate-job match score, the exact score may leak information about the candidate's CV. A recruiter could submit many slightly different job descriptions and observe score changes to infer hidden skills, experience, or certificates.

To reduce that risk, the system can add calibrated Laplace noise:

```text
noisy_score = clamp(true_score + Laplace(0, sensitivity / epsilon), 0, 100)
```

Suggested implementation notes:

- `true_score`: score produced by the matching model.
- `sensitivity`: maximum score change one candidate's hidden data can cause. If scores are normalized to `[0, 100]`, use a bounded sensitivity model.
- `epsilon`: privacy budget. Smaller epsilon gives stronger privacy but lower score accuracy.
- `clamp`: keeps the displayed score inside `[0, 100]`.
- Store the raw score internally only when necessary; expose the noisy score to recruiters.
- Consider caching the noisy score per recruiter-job-candidate tuple to reduce repeated-query averaging attacks.

### Recommended report references

[10] C. Dwork, F. McSherry, K. Nissim, and A. Smith, "Calibrating noise to sensitivity in private data analysis," Journal of Privacy and Confidentiality, vol. 7, no. 3, pp. 17-51, 2017. DOI: https://doi.org/10.29012/jpc.v7i3.405

- Use for: the formal basis of differential privacy and adding noise calibrated to sensitivity.
- Project mapping: match-score noise should be calibrated to the score function's sensitivity.

[11] C. Dwork and A. Roth, "The Algorithmic Foundations of Differential Privacy," Foundations and Trends in Theoretical Computer Science, vol. 9, no. 3-4, pp. 211-407, 2014. DOI: https://doi.org/10.1561/0400000042

- Use for: textbook-level explanation of differential privacy, Laplace mechanism, composition, and privacy budget.
- Project mapping: repeated recruiter queries consume privacy budget and must be controlled.

[12] J. Wang and Q. Tang, "Differentially private neighborhood-based recommender systems," arXiv, 2017. Available: https://arxiv.org/abs/1701.02120

- Use for: applying differential privacy in recommendation systems.
- Project mapping: supports the idea that recommendation outputs and recommendation model parameters can leak user data and can be protected with DP.

[13] S. Gilbert, X. Liu, and H. Yu, "On differentially private online collaborative recommendation systems," arXiv, 2015. Available: https://arxiv.org/abs/1510.08546

- Use for: privacy-utility tradeoffs in online collaborative recommendation.
- Project mapping: useful for discussing the tradeoff between ranking accuracy and candidate privacy.

[14] A. Machanavajjhala, A. Korolova, and A. D. Sarma, "On the (im)possibility of preserving utility and privacy in personalized social recommendations," arXiv, 2010. Available: https://arxiv.org/abs/1004.5600

- Use for: utility limitations when recommendation systems must satisfy strong privacy.
- Project mapping: supports a realistic discussion that privacy protection may reduce recommendation precision.

[15] D. Kifer, S. Messing, A. Roth, A. Thakurta, and D. Zhang, "Guidelines for implementing and auditing differentially private systems," arXiv, 2020. Available: https://arxiv.org/abs/2002.04049

- Use for: implementation and auditing concerns in real DP systems.
- Project mapping: helps justify logging privacy parameters, testing noise generation, and documenting epsilon choices.

### Suggested paragraph for the report

The system applies differential privacy to recruiter-visible match scores by adding calibrated random noise before returning scores to recruiters. This prevents recruiters from using repeated job-description variations to infer hidden candidate attributes from small score changes. Following the Laplace mechanism, the amount of noise is proportional to the score function sensitivity and inversely proportional to the privacy budget `epsilon`. A smaller `epsilon` improves privacy but reduces score precision, so the system must choose a value that balances candidate privacy and recruiter utility.

## Combined Architecture Recommendation

These approaches protect different parts of the system and should be combined rather than treated as replacements:

| Privacy concern | Recommended approach | Example in this project |
| --- | --- | --- |
| Candidate controls profile disclosure | Consent and visibility control | Candidate chooses whether recruiters can see CV file, phone, email, exact education, certificates |
| Recruiter shortlist may identify a candidate | k-anonymity | Generalize location, experience, education, and rare skills until each visible tuple has at least `k` candidates |
| Recruiter may infer hidden CV data from scores | Differential privacy | Add Laplace noise to recruiter-visible match scores |

## Final Report Reference List

[1] European Parliament and Council of the European Union, "Regulation (EU) 2016/679 ... General Data Protection Regulation," Official Journal of the European Union, 2016. Available: https://eur-lex.europa.eu/eli/reg/2016/679/oj

[2] European Data Protection Board, "Guidelines 05/2020 on consent under Regulation 2016/679," 2020. Available: https://www.edpb.europa.eu/documents/guideline/guidelines-052020-on-consent-under-regulation-2016679_en

[3] Information Commissioner's Office, "Guide to the UK GDPR: Individual rights." Available: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/individual-rights/

[4] L. Sweeney, "k-anonymity: A model for protecting privacy," International Journal of Uncertainty, Fuzziness and Knowledge-Based Systems, vol. 10, no. 5, pp. 557-570, 2002. DOI: https://doi.org/10.1142/S0218488502001648

[5] P. Samarati, "Protecting respondents' identities in microdata release," IEEE Transactions on Knowledge and Data Engineering, vol. 13, no. 6, pp. 1010-1027, 2001. DOI: https://doi.org/10.1109/69.971193

[6] P. Samarati and L. Sweeney, "Protecting privacy when disclosing information: k-anonymity and its enforcement through generalization and suppression," SRI International Technical Report, 1998. Available: https://dataprivacylab.org/dataprivacy/projects/kanonymity/paper3.pdf

[7] A. Machanavajjhala, D. Kifer, J. Gehrke, and M. Venkitasubramaniam, "l-diversity: Privacy beyond k-anonymity," ACM Transactions on Knowledge Discovery from Data, vol. 1, no. 1, 2007. DOI: https://doi.org/10.1145/1217299.1217302

[8] N. Li, T. Li, and S. Venkatasubramanian, "t-closeness: Privacy beyond k-anonymity and l-diversity," IEEE ICDE, 2007. DOI: https://doi.org/10.1109/ICDE.2007.367856

[9] D. Slijepcevic, M. Henzl, L. D. Klausner, T. Dam, P. Kieseberg, and M. Zeppelzauer, "k-Anonymity in practice: How generalisation and suppression affect machine learning classifiers," Computers & Security, 2021. Preprint: https://arxiv.org/abs/2102.04763

[10] C. Dwork, F. McSherry, K. Nissim, and A. Smith, "Calibrating noise to sensitivity in private data analysis," Journal of Privacy and Confidentiality, vol. 7, no. 3, pp. 17-51, 2017. DOI: https://doi.org/10.29012/jpc.v7i3.405

[11] C. Dwork and A. Roth, "The Algorithmic Foundations of Differential Privacy," Foundations and Trends in Theoretical Computer Science, vol. 9, no. 3-4, pp. 211-407, 2014. DOI: https://doi.org/10.1561/0400000042

[12] J. Wang and Q. Tang, "Differentially private neighborhood-based recommender systems," arXiv, 2017. Available: https://arxiv.org/abs/1701.02120

[13] S. Gilbert, X. Liu, and H. Yu, "On differentially private online collaborative recommendation systems," arXiv, 2015. Available: https://arxiv.org/abs/1510.08546

[14] A. Machanavajjhala, A. Korolova, and A. D. Sarma, "On the (im)possibility of preserving utility and privacy in personalized social recommendations," arXiv, 2010. Available: https://arxiv.org/abs/1004.5600

[15] D. Kifer, S. Messing, A. Roth, A. Thakurta, and D. Zhang, "Guidelines for implementing and auditing differentially private systems," arXiv, 2020. Available: https://arxiv.org/abs/2002.04049
