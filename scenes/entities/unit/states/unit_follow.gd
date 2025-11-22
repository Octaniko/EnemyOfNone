extends State

@export var rush_state: State = null
@export var idle_state: State = null
@export var follow_speed := 200.0

var follow_target_node: Node2D = null
var follow_target_point: Vector2 = Vector2.ZERO

func set_follow_target(node: Node2D) -> void:
	follow_target_node = node
	follow_target_point = Vector2.ZERO

func set_follow_point(point: Vector2) -> void:
	follow_target_node = null
	follow_target_point = point

func enter() -> void:
	move_speed = follow_speed
	super()
	animations.play(animation_name)
	_update_navigation_target()

func _update_navigation_target() -> void:
	var target = _get_current_target_position()
	if target != null:
		parent.navigation_agent_2d.target_position = target

func _get_current_target_position() -> Vector2:
	if follow_target_node:
		return follow_target_node.global_position
	return follow_target_point

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("rush"):
		return rush_state
	return null

func process_physics(delta: float) -> State:
	var target = _get_current_target_position()
	parent.navigation_agent_2d.target_position = target
	
	if parent.navigation_agent_2d.is_navigation_finished():
		return idle_state
	
	var current_position = parent.global_position
	var next_path_position = parent.navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - current_position).normalized()
	var desired = direction * move_speed
	
	if parent.navigation_agent_2d.avoidance_enabled:
		parent.navigation_agent_2d.set_velocity(desired)
	else:
		_on_navigation_agent_2d_velocity_computed(desired)
	
	parent.move_and_slide()
	parent.animations.flip_h = parent.velocity.x < 0
	
	return null

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parent.velocity = safe_velocity
