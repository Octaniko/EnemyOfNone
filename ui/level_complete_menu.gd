extends Control

@onready var time: Label = $CenterContainer/HBoxContainer/Info/Time
@onready var record: Label = $CenterContainer/HBoxContainer/Info/Record

func _on_restart_pressed() -> void:
	Global.player_level_restart()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_menu/main_menu.tscn")
