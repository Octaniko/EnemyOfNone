class_name State
extends Node

@export var animation_name: String
@export var move_speed := 400

var parent: Enemy

func enter():
	parent.animations.play(animation_name)

func exit():
	pass

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
