extends Control

@onready var intro: VideoStreamPlayer = $CanvasLayer/Control/Intro
@onready var loop: VideoStreamPlayer = $CanvasLayer/Control/Loop
@onready var volume_slider: HSlider = $CanvasLayer/VBoxContainer2/VolumeSlider

const WORLD = preload("res://scenes/levels/world.tscn")

func _ready() -> void:
	volume_slider.value = Global.master_volume_db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_slider.value)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_intro_finished() -> void:
	intro.visible = false

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	Global.master_volume_db = value
