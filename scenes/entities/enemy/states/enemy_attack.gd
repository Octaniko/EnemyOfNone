extends State

@export var follow_state: State
@export var damage: int = 10

@onready var hitbox: Area2D = $"../../AnimatedSprite2D/HitBox"

func enter():
	super()
	animations.play(animation_name)
	# включаем мониторинг хитбокса
	hitbox.set_deferred("monitorable", true)
	hitbox.set_deferred("monitoring", true)

	# подключаем сигнал body_entered, чтобы наносить урон, когда тела входят
	hitbox.body_entered.connect(Callable(self, "_on_body_entered"))

	# ждем физ-шага, чтобы пересечения пересчитались
	await get_tree().physics_frame

	# сразу наносим урон тем, кто уже в зоне
	_deal_damage_to_overlapping()

	# подключаем окончание анимации
	animations.connect("animation_finished", Callable(self, "_on_animation_finished"))

func exit():
	# отключаем хитбокс
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)

	# отключаем сигнал body_entered
	if hitbox.is_connected("body_entered", Callable(self, "_on_body_entered")):
		hitbox.body_entered.disconnect(Callable(self, "_on_body_entered"))

	# отключаем сигнал анимации
	if animations.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		animations.disconnect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_body_entered(body):
	# когда новое тело входит в зону — наносим урон
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _deal_damage_to_overlapping():
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(damage)

func _on_animation_finished():
	# анимация атаки кончилась — возвращаемся к follow_state
	parent.state_machine.change_state(follow_state)
