extends Node

signal interactable_collected
signal interactables_updated(interactables_collected, interactables_total)
signal all_interactables_collected

var master_volume_db: float = -40.0

func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/levels/main_menu/main_menu.tscn")
	Engine.time_scale = 1
	get_tree().paused = false

func player_level_restart():
	Engine.time_scale = 1
	get_tree().paused = false
	get_tree().reload_current_scene()
