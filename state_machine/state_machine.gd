extends Node

@export var starting_state: State

var current_state : State

func init(parent: Enemy) -> void:
	for child in get_children():
		child.parent = parent
	change_state(starting_state)
	
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)  # Update physics logic
	if new_state:
		change_state(new_state)  # Switch state if requested

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
