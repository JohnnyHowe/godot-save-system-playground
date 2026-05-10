## Responsible for reading a single save from persisted storage.
##
## Should only load -> no migrating.
## Uses separate data_read_value signal instead of load() return value to allow async loading.
@abstract
extends RefCounted


@warning_ignore_start("UNUSED_SIGNAL")
signal data_read(data: Variant)
signal no_data_found
@warning_ignore_restore("UNUSED_SIGNAL")


@abstract
func read() -> void
