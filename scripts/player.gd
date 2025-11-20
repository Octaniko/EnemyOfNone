extends CharacterBody2D

@export var movement_speed = 200
@onready var unit_manager: Node2D = $"../UnitManager"
@onready var follow_point: Node2D = $FollowPoint
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

@export var follow_distance := 60.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized() * movement_speed
		follow_point.position = -direction * follow_distance
	if direction > Vector2.ZERO:
		animations.flip_h = false
	elif direction < Vector2.ZERO:
		animations.flip_h = true
	velocity = direction
	move_and_slide()
