extends State

@export var follow_state: State = null
@export var attach_state: State = null
@export var attack_state: State = null
@export var search_time := 0.01

@onready var detection_area: Area2D = $"../../DetectionArea"

var timer := 0.0

func enter() -> void:
	super()
	animations.play(animation_name)
	parent.navigation_agent_2d.target_position = parent.global_position
	timer = 0.0

func process_frame(delta: float) -> State:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	timer += delta
	if timer >= search_time:
		return follow_state
	return null

func _on_detection_area_body_entered(body: Node2D) -> State:
	if parent.state_machine.current_state != self:
		return null
	if body.is_in_group("interactable"):
			attach_state.set_target(body)
			parent.state_machine.change_state(attach_state)
			return null
	return null

func _on_detection_area_body_exited(body: Node2D):
	if parent.state_machine.current_state != self:
		return
