class_name Enemy
extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var targets: Array[Node2D] = []

func _ready():
	state_machine.init(self, animations)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func process_frame(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("targets"):
		targets.append(body)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body in targets:
		targets.erase(body)

func get_nearest_target() -> Node2D:
	if targets.size() == 0:
		return null
	var nearest = targets[0]
	var min_dist = global_position.distance_to(nearest.global_position)
	for body in targets:
		var d = global_position.distance_to(body.global_position)
		if d < min_dist:
			min_dist = d
			nearest = body
	return nearest
