# DTO Guidelines

Use separate DTOs for:
- request body
- query params
- route params
- API response

Rules:
- Do not return raw entities from controllers.
- Keep response DTOs stable and explicit.
- Use class-validator decorators for request DTOs when validation is needed.
- Avoid leaking persistence-only fields.
