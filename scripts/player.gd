extends CharacterBody2D

@onready var follow_point: Node2D = $FollowPoint
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var cursor: Sprite2D = $Cursor

@export var move_speed = 200
@export var follow_distance := 60.0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.back_to_menu()
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized() * move_speed
		follow_point.position = -direction * follow_distance
		cursor.position = direction * follow_distance

	if direction.length() > 5:
		animations.play("move")
	else:
		animations.play("idle")

	if direction.x > 0:
		animations.flip_h = false
	elif direction.x < 0:
		animations.flip_h = true

	velocity = direction
	move_and_slide()
