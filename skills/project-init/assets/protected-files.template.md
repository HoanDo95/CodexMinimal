# Protected Files

Files and folders listed here must not be edited unless explicitly approved in the current task.

## Critical

Critical paths require explicit approval before any edit.

| Path | Reason | Approval Required |
|---|---|---|

## Sensitive

Sensitive paths may contain secrets, credentials, production configuration, or high-risk settings.

| Path | Reason | Approval Required |
|---|---|---|

## Integration

Integration paths are owned by external systems or vendor integrations.

| Path | Reason | Approval Required |
|---|---|---|

## Default Sensitive Areas

- `.env`
- `.env.*`
- secret files
- deployment credentials
- production infra files

## Approval Rule

If a task requires editing a protected path:

1. stop
2. explain why the change is needed
3. ask for explicit approval
