extends Node2D

@export var sound_effects: Array[SoundEffect]
var sound_effect_dict: Dictionary = {}

func _ready() -> void:
	for sfx in sound_effects:
		sound_effect_dict[sfx.type] = sfx

func create_audio(type: int) -> void:
	if not sound_effect_dict.has(type):
		return

	var sfx = sound_effect_dict[type]
	if sfx.has_open_limit():
		sfx.change_audio_count(1)
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = sfx.sound_effect
		player.bus = sfx.bus
		player.volume_db = sfx.volume
		player.pitch_scale = sfx.pitch_scale + randf_range(-sfx.pitch_randomness, sfx.pitch_randomness)
		player.finished.connect(sfx.on_audio_finished)
		player.finished.connect(player.queue_free)
		player.play()

func create_2d_audio_at_location(position: Vector2, type: int) -> void:
	if not sound_effect_dict.has(type):
		return

	var sfx = sound_effect_dict[type]
	if sfx.has_open_limit():
		sfx.change_audio_count(1)
		var player = AudioStreamPlayer2D.new()
		add_child(player)
		player.position = position
		player.stream = sfx.sound_effect
		player.bus = sfx.bus
		player.volume_db = sfx.volume
		player.pitch_scale = sfx.pitch_scale + randf_range(-sfx.pitch_randomness, sfx.pitch_randomness)
		player.finished.connect(sfx.on_audio_finished)
		player.finished.connect(player.queue_free)
		player.play()
