# Repository Guidelines

For important state transitions:
- prefer explicit repository methods
- avoid `find -> merge -> save`
- keep update semantics clear
- verify affected rows when important
- keep TypeORM `synchronize: false`

Repositories should hide persistence details from services when the domain transition is important.
