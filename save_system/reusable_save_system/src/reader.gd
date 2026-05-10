## Responsible for reading a single save from persisted storage.
##
## Should only load -> no migrating.
## Uses separate data_read signal instead of load() return value to allow async loading.
##
## Implementations should NOT start reading until load() is called -> NOT on _init.
@abstract
extends RefCounted


@warning_ignore("UNUSED_SIGNAL")
signal data_read(data: Variant)


@abstract
func read() -> void
