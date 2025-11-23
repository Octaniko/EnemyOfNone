extends Control

@onready var intro: VideoStreamPlayer = $CanvasLayer/Control/Intro
@onready var loop: VideoStreamPlayer = $CanvasLayer/Control/Loop

const WORLD = preload("res://scenes/levels/world.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_intro_finished() -> void:
	intro.visible = false
