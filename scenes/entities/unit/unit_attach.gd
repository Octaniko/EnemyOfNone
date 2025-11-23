extends State
class_name UnitAttach

@export var idle_state: State = null
@export var follow_state: State = null
@export var follow_speed: float = 200.0

var attach_target: Node2D = null

func set_target(body: Node2D) -> void:
	attach_target = body
	print("[Attach] set_target called. Target:", body, " valid:", is_instance_valid(body))

func enter() -> void:
	print("[Attach] enter. Current target:", attach_target)
	animations.play(animation_name)
	_update_navigation_target()

func _update_navigation_target() -> void:
	if not attach_target or not is_instance_valid(attach_target):
		print("[Attach] _update_navigation_target: no valid target!")
		return
	var target_pos = attach_target.global_position
	print("[Attach] _update_navigation_target: setting nav target to", target_pos)
	parent.navigation_agent_2d.target_position = target_pos

func process_physics(delta: float) -> State:
	# Проверки
	if attach_target == null:
		print("[Attach] process_physics: attach_target is null → going idle")
		return idle_state
	if not is_instance_valid(attach_target):
		print("[Attach] process_physics: attach_target is not valid (instance freed?) → going idle")
		return idle_state

	# Обновить цель навигации
	_update_navigation_target()

	# Навигация — получаем следующий путь
	var next_pos: Vector2 = parent.navigation_agent_2d.get_next_path_position()
	print("[Attach] process_physics: next_path_position:", next_pos, " my pos:", parent.global_position)

	# Направление
	var dir = (next_pos - parent.global_position)
	var distance = dir.length()
	if distance == 0:
		print("[Attach] process_physics: distance to next point is zero!")
	else:
		dir = dir.normalized()
	var desired = dir * follow_speed
	print("[Attach] process_physics: dir:", dir, " desired velocity:", desired)

	# Установка скорости
	if parent.navigation_agent_2d.avoidance_enabled:
		parent.navigation_agent_2d.set_velocity(desired)
		print("[Attach] process_physics: using avoidance, set_velocity:", desired)
	else:
		_on_navigation_agent_2d_velocity_computed(desired)
		print("[Attach] process_physics: avoidance disabled, directly setting velocity")

	# Движение
	parent.move_and_slide()
	print("[Attach] process_physics: after move_and_slide, global_position:", parent.global_position)

	# Анимация
	parent.animations.flip_h = parent.velocity.x < 0
	animations.play(animation_name)

	return null  # остаёмся в attach

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parent.velocity = safe_velocity
	print("[Attach] _on_navigation_agent_2d_velocity_computed: safe_velocity:", safe_velocity)

func exit() -> void:
	print("[Attach] exit. Clearing target.")
	attach_target = null
