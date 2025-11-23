extends State

@export var follow_state: State = null
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

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("recall"):
		return follow_state
	return null

func _on_detection_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detection_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
