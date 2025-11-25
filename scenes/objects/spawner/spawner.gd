extends Node2D

@export var carryable_scene: PackedScene = preload("res://scenes/objects/carryables/emergency_carryable.tscn")
@export var spawn_cooldown := 30.0

var current_instance: Node = null
var overlapping_bodies := []

@onready var timer: Timer = $Timer
@onready var area: Area2D = $Area2D
@onready var progress_bar: ColorRect = $ProgressBar

func _ready() -> void:
	_spawn_carryable()
	timer.wait_time = spawn_cooldown
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))

func _process(delta: float) -> void:
	if not timer.is_paused():
		var t = timer.time_left
		var frac = (spawn_cooldown - t) / spawn_cooldown
		progress_bar.material.set_shader_parameter("progress", frac)
	else:
		progress_bar.material.set_shader_parameter("progress", 1.0)

func _on_timer_timeout():
	if is_instance_valid(current_instance):
		return
	_spawn_carryable()

func _spawn_carryable():
	var carryable = carryable_scene.instantiate()
	add_child(carryable)
	carryable.global_position = global_position
	current_instance = carryable

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_class() == carryable_scene.resource_path.get_file().get_basename():
		overlapping_bodies.append(body)
		timer.paused = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if overlapping_bodies.has(body):
		overlapping_bodies.erase(body)
	if overlapping_bodies.size() ==0:
		timer.paused = false
