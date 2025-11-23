extends CharacterBody2D
class_name Carryable

@export var required_units := 2
@export var speed := 50.0

@onready var detection_area: Area2D = $DetectionArea
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var count_label: Label = $CountLabel

var units_in_area: Array[CharacterBody2D] = []
var approved_units: Array[CharacterBody2D] = []

func _ready() -> void:
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("units"):
		return
	if body.has_method("get_state_name"):
		var state = body.get_state_name()
		if state != "Attach":
			return
	else:
		return
	if not units_in_area.has(body):
		units_in_area.append(body)
	_check_units_count()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("units"):
		if units_in_area.has(body):
			units_in_area.erase(body)
		if approved_units.has(body):
			approved_units.erase(body)
	_check_units_count()

func _check_units_count() -> void:
	var free_slots = required_units - approved_units.size()
	for unit in units_in_area:
		if free_slots <= 0:
			break
		if not approved_units.has(unit):
			approved_units.append(unit)
			if unit.has_method("on_attach_approved"):
				unit.on_attach_approved(self)
			free_slots -= 1
	
	for unit in units_in_area:
		if not approved_units.has(unit):
			if unit.has_method("on_detach_extra"):
				unit.on_detach_extra(self)
	
	if units_in_area.size() >= required_units:
		_start_move_to_base()
	else:
		_stop_moving()

func _start_move_to_base() -> void:
	var base = get_tree().get_nodes_in_group("base")[0]
	if base == null:
		print("Base not found!")
		return
	navigation_agent_2d.target_position = base.global_position

func _stop_moving() -> void:
	navigation_agent_2d.target_position = global_position

func _physics_process(delta: float) -> void:
	if not navigation_agent_2d.is_target_reached():
		var next_path_position = navigation_agent_2d.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	_check_units_count()
	count_label.text = str(units_in_area.size()) + "/" + str(required_units)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
