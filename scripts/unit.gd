extends CharacterBody2D

@export var movement_speed: float = 200.0
@export var target: Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	call_deferred("seeker_setup")

func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
