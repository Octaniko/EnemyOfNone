extends Node

@export var unit_limit := 20
@export var base: Node2D = null
@export var unit_scene: PackedScene = preload("res://scenes/entities/unit/unit.tscn")

var units_reserved := 0

func _ready() -> void:
	Global.interactable_collected.connect(Callable(self, "_on_interactable_collected"))

func _on_interactable_collected():
	units_reserved += 1

func _process(delta: float) -> void:
	var units_active = get_tree().get_nodes_in_group("units").size()
	if units_active < unit_limit and units_reserved > 0:
		spawn_unit()
		units_reserved -= 1

func spawn_unit():
	var unit_instance = unit_scene.instantiate()
	unit_instance.position = base.global_position
	add_child(unit_instance)
