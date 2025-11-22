extends State

@export var idle_state: State = null
@export var rush_speed: float = 400.0
const ARRIVAL_TOLERANCE := 4.0

var rush_target: Vector2

func enter() -> void:
	animations.play(animation_name)
	var input_dir = parent.last_player_input
	rush_target = parent.global_position + input_dir.normalized() * (rush_speed * 0.5)

func process_physics(delta: float) -> State:
	var pos = parent.global_position
	var to_target = rush_target - pos
	var dist = to_target.length()
	
	if dist <= ARRIVAL_TOLERANCE:
		return idle_state
	
	var dir = to_target.normalized()
	var velocity = dir * rush_speed
	
	var collision = parent.move_and_collide(velocity * delta)
	if collision:
		return idle_state
	
	parent.animations.flip_h = dir.x < 0
	
	return null
