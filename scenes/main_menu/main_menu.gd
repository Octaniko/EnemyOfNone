extends VBoxContainer

const WORLD = preload("uid://srlmnfge160e")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
