extends CharacterBody2D

@export var movement_speed := 200.0
@export var health := 1
@export var step_interval: float = 0.15

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var state_machine: Node = $StateMachine
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

var interactables: Array[Node2D] = []
var last_player_input: Vector2 = Vector2.UP
var player: CharacterBody2D
var follow_point: Node2D
var step_timer: float = 0.0

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	follow_point = player.get_node("FollowPoint")
	state_machine.init(self, animations)
	state_machine.get_node("Follow").set_follow_target(follow_point)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	var current_speed = navigation_agent_2d.velocity.length()

	if current_speed > 5.0:
		step_timer -= delta
		if step_timer <= 0.0:
			AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.UNIT_WALK)
			step_timer = step_interval
	else:
		step_timer = 0.0
		
func _input(event: InputEvent) -> void:
	var new_state = state_machine.current_state.process_input(event)
	if new_state:
		state_machine.change_state(new_state)
		return
	
	if event.is_action_pressed("recall"):
		var follow_state = state_machine.get_node("Follow")
		state_machine.change_state(follow_state)
		return
	_process_player_input(event)

func _process_player_input(event: InputEvent) -> void:
	if event is InputEvent and event.is_pressed():
		var direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		if direction != Vector2.ZERO:
			last_player_input = direction.normalized()

func get_state_name() -> String:
	return state_machine.current_state.name

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.UNIT_DIE)
	get_tree().call_group("unit_manager", "on_unit_died")
	queue_free()
