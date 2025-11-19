class_name Enemy
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine

func process_physics(delta: float) -> void:
	state_machine.process_physics(delta)

func process_frame(delta: float) -> void:
	state_machine.process_frame(delta)
