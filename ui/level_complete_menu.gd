extends Control

@onready var record_label: Label = $CenterContainer/VBoxContainer/Info/Record
@onready var time_label: Label = $CenterContainer/VBoxContainer/Info/Time
@onready var new_record_message: Label = $CenterContainer/VBoxContainer/Info/NewRecordMessage
@onready var level_complete_sound: AudioStreamPlayer = $LevelCompleteSound
@onready var new_record_sound: AudioStreamPlayer = $NewRecordSound

var level_name: String

var minutes := 0
var seconds := 0
var milliseconds := 0

func _ready() -> void:
	var level_timer_container = get_tree().current_scene.find_child("LevelTimerContainer", true, false)
	if level_timer_container:
		level_timer_container.connect("time_sent", Callable(self, "_on_time_sent"))

func _on_restart_pressed() -> void:
	Global.player_level_restart()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_menu/main_menu.tscn")

func _on_time_sent(elapsed_time: float) -> void:
	var record = RecordManager.get_record(level_name)
	minutes = fmod(elapsed_time, 3600) / 60
	seconds = fmod(elapsed_time, 60)
	milliseconds = fmod(elapsed_time, 1) * 1000
	time_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	if check_new_record(elapsed_time):
		new_record_message.visible = true
		new_record_sound.play()
		RecordManager.set_record(level_name, elapsed_time)
	else:
		level_complete_sound.play()
	current_record()

func check_new_record(elapsed_time: float) -> bool:
	var record = RecordManager.get_record(level_name)
	var is_new_record = elapsed_time < record
	return is_new_record

func current_record():
	var record = RecordManager.get_record(level_name)
	minutes = fmod(record, 3600) / 60
	seconds = fmod(record, 60)
	milliseconds = fmod(record, 1) * 1000
	record_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
