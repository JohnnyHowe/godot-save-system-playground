## Index/namespace for the reusable save system.
## Allows just one global namespace entry
class_name ReusableSaveSystem

const Reader := preload("./src/reader.gd")
const Writer := preload("./src/writer.gd")
const Manager := preload("./src/manager.gd")
const LoadPipeline := preload("./src/load_pipeline.gd")
const MigrationPipeline := preload("./src/migration_pipeline.gd")
const Migrator := preload("./src/migrator.gd")
const SaveSelection := preload("./src/save_selection.gd")
