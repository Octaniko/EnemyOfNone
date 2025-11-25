extends State

@export var idle_state: State

@onready var hitbox: HitBox = $"../../AnimatedSprite2D/HitBox"

func enter():
	super()
	animations.play(animation_name)
	hitbox.set_deferred("monitorable", true)

func exit():
	hitbox.set_deferred("monitorable", false)
