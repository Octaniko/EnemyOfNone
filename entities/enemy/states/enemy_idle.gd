extends State

@export var follow_state: State

var targets: Array[Node2D] = []

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	
	if targets.size() > 0:
		return follow_state
	return null

func _on_detection_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
