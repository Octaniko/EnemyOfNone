extends State

@export var rush_state: State = null
@export var idle_state: State = null
@export var follow_speed := 200.0

@onready var parent_animations: AnimatedSprite2D = $"../../AnimatedSprite2D"

func enter() -> void:
	move_speed = follow_speed
	super()
	animations.play(animation_name)
	parent.set_meta("dismissed", false)
	if parent.has_method("get_follow_target_position"):
		parent.navigation_agent_2d.target_position = parent.get_follow_target_position()

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("rush"):
		return rush_state
	if event.is_action_pressed("dismiss"):
		parent.set_meta("dismissed", true)
		return idle_state
	return null

func process_physics(delta: float) -> State:
	if parent and parent.has_method("get_follow_target_position"):
		parent.navigation_agent_2d.target_position = parent.get_follow_target_position()
	if parent.navigation_agent_2d.is_navigation_finished():
		parent.velocity = Vector2.ZERO
		parent_animations.play("idle")
		return null
		
	var current_agent_position = parent.global_position
	var next_path_position = parent.navigation_agent_2d.get_next_path_position()
	var dir = (next_path_position - current_agent_position).normalized()
	
	parent.velocity = dir * move_speed
	parent.move_and_slide()
	parent.animations.flip_h = parent.velocity.x < 0
	
	return null
