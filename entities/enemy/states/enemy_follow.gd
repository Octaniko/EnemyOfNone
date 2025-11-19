extends State

@export var idle_state: State

func enter() -> void:
	super()
	parent.navigation_agent_2d.target_position = parent.global_position

func process_physics(delta: float) -> State:
	var target = parent.get_nearest_target()
	print("Nearest target: ", target)
	if not target:
		print("No target, switching to idle")
		return idle_state
	parent.navigation_agent_2d.target_position = target.global_position
	var next_path_position = parent.navigation_agent_2d.get_next_path_position()
	print("Agent next path position: ", next_path_position)
	parent.velocity = (next_path_position - parent.global_position).normalized() * move_speed
	print("Computed velocity: ", parent.velocity)
	parent.move_and_slide()

	return null
