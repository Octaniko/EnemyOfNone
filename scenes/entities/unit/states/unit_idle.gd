extends State

@export var seek_state: State = null
@export var follow_state: State = null
@export var search_time := 0.12

func enter() -> void:
	super()
	animations.play(animation_name)
	parent.navigation_agent_2d.target_position = parent.global_position

func process_frame(delta: float) -> State:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	return null

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("recall"):
		parent.set_meta("dismissed", false)
		return follow_state
	return null
