extends State
class_name EnemyFollow

@export var idle_state: State
@export var attack_state: State

func enter() -> void:
	super()
	animations.play(animation_name)
	parent.navigation_agent_2d.target_position = parent.global_position

func process_physics(delta: float) -> State:
	var target = parent.get_nearest_target()
	if not target:
		return idle_state

	parent.navigation_agent_2d.target_position = target.global_position
	var next_path_position = parent.navigation_agent_2d.get_next_path_position()
	parent.velocity = (next_path_position - parent.global_position).normalized() * move_speed
	parent.move_and_slide()

	# проверяем, попал ли агент в зону атаки
	if parent.navigation_agent_2d.is_target_reached():
		return attack_state

	return null
