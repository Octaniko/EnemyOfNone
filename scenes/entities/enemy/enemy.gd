class_name Enemy
extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var health_bar: ColorRect = $ProgressBar

@export var carcass_scene : PackedScene
@export var max_health := 10

var health: int

var targets: Array[Node2D] = []

func _ready():
	health = max_health
	state_machine.init(self, animations)
	_update_health_bar()

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

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)
	_update_health_bar()
	if health <= 0:
		die()

func die() -> void:
	_spawn_carcass()
	queue_free()

func _spawn_carcass():
	if carcass_scene == null:
		return
	var carcass_instance = carcass_scene.instantiate()
	carcass_instance.global_position = global_position
	get_tree().current_scene.add_child(carcass_instance)

func _update_health_bar() -> void:
	var fraction := float(health) / float(max_health)
	fraction = clamp(fraction, 0.0, 1.0)
	var mat = health_bar.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("progress", fraction)
	else:
		health_bar.size.x = health_bar.get_parent().size.x * fraction
