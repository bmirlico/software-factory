---
name: roadmap
description: Use after PRD and architecture are validated. Splits the product into ordered, independently shippable features and creates GitHub issues. Each issue then goes through /spec.
---
Prerequisites: validated PRD and ARCHITECTURE.
1. Extract the Must then Should features from the PRD. Split any feature larger than ~3 days of work into sub-features that can ship on their own.
2. Order by technical dependency (foundations first: skeleton, auth, data model), then by value.
3. Write `docs/ROADMAP.md`: table (order, feature, one-line scope, depends on, value, status).
4. For each feature: `gh issue create --label feature --title "<feature>" --body "<scope + dependencies + PRD link>"`.
5. Display the roadmap. Do not detail the specs here: that is /spec, one at a time.
6. Then run the `spec` skill right away on the first feature of the list (the skeleton), without waiting to be asked.
