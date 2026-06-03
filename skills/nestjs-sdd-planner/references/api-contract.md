# API Contract

Define the contract before planning code.

For each endpoint or handler, specify:

- method or trigger
- route or entry point
- request DTO fields with types and validation
- response DTO fields with types
- status codes or success states
- error responses and when they occur

Contract rules:

- prefer explicit DTOs over vague payload descriptions
- state required versus optional fields
- note enum values or accepted ranges
- describe backward-compatibility impact if an existing contract changes
