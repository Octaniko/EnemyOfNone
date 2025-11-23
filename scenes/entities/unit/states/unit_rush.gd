extends State

@export var idle_state: State = null
@export var attach_state: State = null
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


func _on_detection_area_body_entered(body: Node2D) -> State:
	if parent.state_machine.current_state != self:
		return null
	if body.is_in_group("interactable"):
		if body.is_in_group("carryable"):
			print("Body is carryable")
			return attach_state
		elif body.is_in_group("enemies"):
			return attach_state
	return null


func _on_detection_area_body_exited(body: Node2D):
	if parent.state_machine.current_state != self:
		return null
	if body.is_in_group("interactable"):
		print("Body left")
