extends State
class_name UnitAttach

@onready var hitbox: HitBox = $"../../AnimatedSprite2D/HitBox"

@export var idle_state: State = null
@export var follow_state: State = null
@export var follow_speed: float = 200.0
@export var carry_step_interval: float = 0.5

var carry_step_timer: float = 0.0
var attach_target: Node2D = null

func set_target(body: Node2D) -> void:
	attach_target = body

func enter():
	super()
	animations.play(animation_name)
	hitbox.set_deferred("monitorable", true)
	_update_navigation_target()

func _update_navigation_target() -> void:
	if not attach_target or not is_instance_valid(attach_target):
		return
	var target_pos = attach_target.global_position
	parent.navigation_agent_2d.target_position = target_pos

func process_physics(delta: float) -> State:
	if not attach_target or not is_instance_valid(attach_target):
		return idle_state

	_update_navigation_target()

	var next_pos: Vector2 = parent.navigation_agent_2d.get_next_path_position()
	var direction = (next_pos - parent.global_position)
	var distance = direction.length()
	if distance != 0:
		direction = direction.normalized()
	var desired = direction * follow_speed

	if parent.navigation_agent_2d.avoidance_enabled:
		parent.navigation_agent_2d.set_velocity(desired)
	else:
		_on_navigation_agent_2d_velocity_computed(desired)

	parent.move_and_slide()

	parent.animations.flip_h = parent.velocity.x < 0
	var speed = parent.velocity.length()
	if speed > 5.0:
		carry_step_timer -= delta
		if carry_step_timer <= 0.0:
			AudioManager.create_2d_audio_at_location(parent.global_position, SoundEffect.SOUND_EFFECT_TYPE.UNIT_CARRY)
			carry_step_timer = carry_step_interval
	else:
		carry_step_timer = 0.0

	return null

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parent.velocity = safe_velocity

func exit() -> void:
	attach_target = null
	hitbox.set_deferred("monitorable", false)
