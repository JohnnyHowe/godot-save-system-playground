## Responsible for upgrading save data from one version to the next.
@abstract
extends RefCounted


@abstract
func can_migrate(save_data: Variant) -> bool


## Migrates data to the next version.
## If it turns out the data cannot be migrated, null can be returned.
@abstract
func migrate(save_data: Variant) -> Variant
