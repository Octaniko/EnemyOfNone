extends Node

const SAVE_PATH := "user://data/record_data.tres"

var record_data: RecordData

func _ready():
	var dir = DirAccess.open("user://data")
	if dir == null:
		var error = DirAccess.make_dir_absolute("user://data")

	if FileAccess.file_exists(SAVE_PATH):
		record_data = ResourceLoader.load(SAVE_PATH, "RecordData")
	else:
		record_data = RecordData.new()
		save_records()

func set_record(level_name: String, time_value: float) -> bool:
	var key = level_name.to_lower()
	if not record_data.records.has(key) or time_value < record_data.records[key]:
		record_data.records[key] = time_value
		save_records()
		return true
	return false

func get_record(level_name: String) -> float:
	var key = level_name.to_lower()
	return record_data.records.get(key, INF)

func save_records():
	ResourceSaver.save(record_data, SAVE_PATH)
