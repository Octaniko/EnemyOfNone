extends State

@export var idle_state: State

var player: CharacterBody2D
var unit: CharacterBody2D

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	return null
