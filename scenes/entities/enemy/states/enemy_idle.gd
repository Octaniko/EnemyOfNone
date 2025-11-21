extends State

@export var follow_state: State

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_physics(delta: float) -> State:
	if parent.get_nearest_target():
		return follow_state
	parent.move_and_slide()
	return null
