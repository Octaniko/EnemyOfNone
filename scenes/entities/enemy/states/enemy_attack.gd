extends State

@export var follow_state: State
@export var damage: int = 10

@onready var hitbox: Area2D = $"../../AnimatedSprite2D/HitBox"

func enter():
	super()
	animations.play(animation_name)
	hitbox.set_deferred("monitorable", true)
	hitbox.body_entered.connect(Callable(self, "_on_body_entered"))
	await get_tree().physics_frame
	_deal_damage_to_overlapping()
	animations.connect("animation_finished", Callable(self, "_on_animation_finished"))

func exit():
	hitbox.set_deferred("monitorable", false)
	if hitbox.is_connected("body_entered", Callable(self, "_on_body_entered")):
		hitbox.body_entered.disconnect(Callable(self, "_on_body_entered"))
	if animations.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		animations.disconnect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _deal_damage_to_overlapping():
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(damage)

func _on_animation_finished():
	parent.state_machine.change_state(follow_state)
