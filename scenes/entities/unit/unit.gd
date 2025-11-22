extends CharacterBody2D

@export var movement_speed := 200.0
@export var rush_distance := 200.0

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var state_machine: Node = $StateMachine

var interactables: Array[Node2D] = []
var last_player_input: Vector2 = Vector2.UP
var player: CharacterBody2D
var follow_point: Node2D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	follow_point = player.get_node("FollowPoint")
	state_machine.init(self, animations)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	_process_player_input(event)

func _process_player_input(event: InputEvent) -> void:
	if event is InputEvent and event.is_pressed():
		var direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		if direction != Vector2.ZERO:
			last_player_input = direction.normalized()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		interactables.append(body)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		interactables.erase(body)

func get_nearest_interactable() -> Node2D:
	if interactables.size() == 0:
		return null
	var nearest = interactables[0]
	var minimal_distance = global_position.distance_to(nearest.global_position)
	for item in interactables:
		var distance = global_position.distance_to(item.global_position)
		if distance < minimal_distance:
			minimal_distance = distance
			nearest = item
	return nearest

func get_follow_target_position() -> Vector2:
	return follow_point.global_position

func get_rush_target_point() -> Vector2:
	return global_position + last_player_input * rush_distance
