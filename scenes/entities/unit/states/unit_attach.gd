extends State
class_name UnitAttach

@export var idle_state: State = null
@export var follow_state: State = null
@export var follow_speed: float = 200.0

var attach_target: Node2D = null
var is_approved := false

func set_target(body: Node2D) -> void:
	attach_target = body
	is_approved = false

func enter() -> void:
	super()
	animations.play(animation_name)
	_update_navigation_target()

func _update_navigation_target() -> void:
	if not attach_target or not is_instance_valid(attach_target):
		return
	var target_pos = attach_target.global_position
	parent.navigation_agent_2d.target_position = target_pos

func process_physics(delta: float) -> State:
	if attach_target == null:
		return idle_state
	if not is_instance_valid(attach_target):
		return idle_state

	_update_navigation_target()

	var next_pos: Vector2 = parent.navigation_agent_2d.get_next_path_position()

	var dir = (next_pos - parent.global_position)
	var distance = dir.length()
	if distance == 0:
		print("[Attach] process_physics: distance to next point is zero!")
	else:
		dir = dir.normalized()
	var desired = dir * follow_speed

	if parent.navigation_agent_2d.avoidance_enabled:
		parent.navigation_agent_2d.set_velocity(desired)
	else:
		_on_navigation_agent_2d_velocity_computed(desired)

	parent.move_and_slide()

	parent.animations.flip_h = parent.velocity.x < 0
	animations.play(animation_name)

	return null

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parent.velocity = safe_velocity

func exit() -> void:
	attach_target = null
