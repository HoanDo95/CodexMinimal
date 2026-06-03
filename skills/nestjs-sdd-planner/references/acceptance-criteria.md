# Acceptance Criteria

Use behavior-focused criteria, not implementation tasks.

Recommended format:

- Given [initial state]
- When [user or system action]
- Then [observable outcome]

Rules:

- describe externally visible behavior
- keep one behavior per criterion where possible
- include success path, validation failures, and permission or conflict cases
- avoid wording that depends on a specific method or class name

Minimum set for a new feature:

- happy path
- invalid input
- missing dependency or missing resource
- permission or access control case if relevant
- idempotency or duplicate handling if relevant
