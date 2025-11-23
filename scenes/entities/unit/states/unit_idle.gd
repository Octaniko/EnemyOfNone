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
	print("[Idle] current_state:", parent.state_machine.current_state)
	print("[Idle] _on_detection_area_body_entered. Body:", body)
	if parent.state_machine.current_state != self:
		print("[Idle] but current state is not Idle → ignore")
		return null
	if body.is_in_group("interactable"):
		print("[Idle] body is in group 'interactable'")
		if body.is_in_group("carryable") or body.is_in_group("enemies"):
			print("[Idle] body is carryable or enemy, will attach. Calling set_target.")
			# Использую правильный call_deferred
			attach_state.set_target(body)
			print("[Idle] deferred set_target called.")
			return attach_state
	print("[Idle] no valid group match → ignore")
	return null

func _on_detection_area_body_exited(body: Node2D):
	print("[Idle] _on_detection_area_body_exited. Body:", body)
	if parent.state_machine.current_state != self:
		print("[Idle] but current state is not Idle → ignore exit")
		return
	if body.is_in_group("interactable"):
		print("[Idle] body left detection area:", body)
	# не переключаем состояние здесь – можно сделать, если нужно
