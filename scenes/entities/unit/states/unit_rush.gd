# todo: make so only one rushes
# todo: figure out why recall doesn't get everyone sometimes
# todo: they need to rush forward and stop if there's an obstacle, not go behind walls
extends State

@export var idle_state: State = null
@export var follow_state: State = null
@export var rush_speed := 320
@export var reach_tolerance := 8.0

var rush_target: Vector2

func enter() -> void:
	move_speed = rush_speed
	super()
	
	rush_target = parent.get_rush_target_point()
	parent.navigation_agent_2d.target_position = rush_target
	parent.set_meta("just_rushed", true)

func process_physics(delta: float) -> State:
	if parent.navigation_agent_2d.is_navigation_finished():
		return idle_state
	
	var next_path_position = parent.navigation_agent_2d.get_next_path_position()
	parent.velocity = (next_path_position - parent.global_position).normalized() * move_speed
	parent.move_and_slide()
	parent.animations.flip_h = false if parent.velocity.x > 0 else true
	
	if parent.global_position.distance_to(rush_target) <= reach_tolerance:
		return idle_state
	
	return null

func process_input(event: InputEvent) -> State:
	if event is InputEventAction and event.is_action_pressed("recall"):
		return follow_state
	return null
