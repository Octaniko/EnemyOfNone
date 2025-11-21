extends State

@export var rush_state: State = null
@export var idle_state: State = null
@export var follow_speed := 200.0

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
		parent.animations.play("idle")
		return null
		
	var current_agent_position = parent.global_position
	var next_path_position = parent.navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - current_agent_position).normalized()
	var new_direction = direction * move_speed
	
	if parent.navigation_agent_2d.avoidance_enabled:
		parent.navigation_agent_2d.set_velocity(new_direction)
	else:
		_on_navigation_agent_2d_velocity_computed(new_direction)
	
	parent.move_and_slide()
	parent.animations.flip_h = parent.velocity.x < 0
	
	return null

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parent.velocity = safe_velocity
