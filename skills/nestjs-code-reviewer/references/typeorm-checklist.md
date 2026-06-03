# TypeORM Checklist

Check:
- `synchronize: false`
- safe migrations
- no accidental destructive schema change
- important state transitions use explicit update semantics
- no unsafe `find -> merge -> save` for critical transitions
- relations are intentionally loaded
- transactions are used when consistency requires them
