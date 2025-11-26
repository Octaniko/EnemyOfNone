extends CharacterBody2D

@onready var follow_point: Node2D = $FollowPoint
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var cursor: Sprite2D = $Cursor

@export var move_speed: float = 200
@export var follow_distance: float = 60.0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.back_to_menu()

	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	velocity = direction.normalized() * move_speed if direction != Vector2.ZERO else Vector2.ZERO
	move_and_slide()

	if direction != Vector2.ZERO:
		follow_point.global_position = global_position + (-direction.normalized() * follow_distance)
		cursor.global_position = global_position + (direction.normalized() * follow_distance)

	if velocity.length() > 0:
		animations.play("move")
	else:
		animations.play("idle")

	animations.flip_h = velocity.x < 0
	
	if Input.is_action_just_pressed("recall"):
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.RECALL)
