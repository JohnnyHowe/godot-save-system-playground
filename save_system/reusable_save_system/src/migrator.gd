## Responsible for upgrading save data from one version to the next.
@abstract
extends RefCounted


@abstract
func can_migrate(save_data: RefCounted) -> RefCounted


@abstract
func migrate(save_data: RefCounted) -> RefCounted
