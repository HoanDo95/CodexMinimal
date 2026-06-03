# Architecture Rules

Default NestJS boundaries:
- feature modules by domain
- controllers call services
- services own business behavior
- persistence belongs inside feature directory
- controllers return DTOs
- entities are persistence models
- jobs should not be wired into web runtime
