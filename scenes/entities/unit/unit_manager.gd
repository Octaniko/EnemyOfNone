extends Node

@export var unit_limit := 20
@export var base: Node2D = null
@export var unit_scene: PackedScene = preload("res://scenes/entities/unit/unit.tscn")

var units_reserved := 0

signal units_changed(units_active: int, units_reserced: int, units_total: int)

func _ready() -> void:
	Global.interactable_collected.connect(Callable(self, "_on_interactable_collected"))

func _on_interactable_collected():
	units_reserved += 1
	_emit_units_changed()

func _process(delta: float) -> void:
	var units_active = get_tree().get_nodes_in_group("units").size()
	if units_active < unit_limit and units_reserved > 0:
		spawn_unit()
		units_reserved -= 1
		_emit_units_changed()
	if units_active == 0 and units_reserved == 0:
		spawn_unit()
		_emit_units_changed()

func spawn_unit():
	var unit_instance = unit_scene.instantiate()
	unit_instance.global_position = base.global_position
	add_child(unit_instance)

func _emit_units_changed():
	var units_active = get_tree().get_nodes_in_group("units").size()
	var units_total = units_active + units_reserved
	emit_signal("units_changed", units_active, units_reserved, units_total)

func get_reserved() -> int:
	return units_reserved

func get_active() -> int:
	return get_tree().get_nodes_in_group("units").size()

func add_units_emergency():
	units_reserved += 2
	_emit_units_changed()

func on_unit_died():
	_emit_units_changed()
