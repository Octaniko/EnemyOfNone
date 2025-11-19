class_name State
extends Node

@export var animation_name: String
@export var move_speed := 100

var parent: CharacterBody2D
var animations: AnimatedSprite2D

func enter():
	animations.play(animation_name)

func exit():
	pass

func process_physics(delta: float) -> State:
	return null

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
