extends CharacterBody2D

@export var speed = 200
@onready var unit_manager: Node2D = $"../UnitManager"

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized() * speed

	velocity = input_vector
	move_and_slide()
