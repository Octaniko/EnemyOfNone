extends Node

@export var scene_music: AudioStream
@onready var hud: Control = $"../UI/HUD"
@onready var level_complete_screen: Control = $"../UI/LevelCompleteMenu"

var interactables_total := 0
var interactables_collected := 0

func _ready() -> void:
	interactables_total = get_tree().get_nodes_in_group("interactable").size()

	var result = Global.connect("interactable_collected", Callable(self, "_on_interactable_collected"))

	call_deferred("_emit_initial_update")

func _emit_initial_update() -> void:
	Global.emit_signal("interactables_updated", interactables_collected, interactables_total)

	if interactables_collected == interactables_total:
		Global.emit_signal("all_interactables_collected")
		get_tree().paused = true
		hud.visible = false
		level_complete_screen.visible = true

func _on_interactable_collected() -> void:
	interactables_collected += 1

	Global.emit_signal("interactables_updated", interactables_collected, interactables_total)

	if interactables_collected == interactables_total:
		Global.emit_signal("all_interactables_collected")
		get_tree().paused = true
		hud.visible = false
		level_complete_screen.visible = true
