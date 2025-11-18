extends CharacterBody2D

@export var speed: float = 200.0

# Ссылка на NavigationAgent2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D

# Целевая точка, за которой идет юнит (установит внешний менеджер)
var target_position: Vector2 = Vector2.ZERO

func _ready():
	# Параметры агента: как близко подходит к пути и к цели
	agent.path_desired_distance = 15.0
	agent.target_desired_distance = 15.0
	# Ждем первый кадр физики, чтобы сервер навигации синхронизировался
	call_deferred("_post_ready")

func _post_ready():
	await get_tree().physics_frame
	# Устанавливаем начальную цель
	agent.target_position = target_position

func set_target(pos: Vector2):
	target_position = pos
	agent.target_position = pos

func _physics_process(delta):
	if agent.is_navigation_finished():
		# если достигли цели, можно остановиться или просто не двигаться
		velocity = Vector2.ZERO
	else:
		var next_point = agent.get_next_path_position()
		# Направление к следующей точке:
		var dir = (next_point - global_position).normalized()
		velocity = dir * speed
	# перемещаемся
	move_and_slide()

	# Можно обновлять цель динамически, если target_position часто меняется:
	agent.target_position = target_position
