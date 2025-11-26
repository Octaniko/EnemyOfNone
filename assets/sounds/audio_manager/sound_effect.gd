extends Resource
class_name SoundEffect

enum SOUND_EFFECT_TYPE {
	UNIT_WALK,
	UNIT_ATTACK,
	UNIT_DIE,
	UNIT_CARRY,
	ENEMY_WALK,
	ENEMY_DIE,
	RUSH,
	RECALL,
	UNIT_ALERT
}

@export_range(0, 10) var limit: int = 5
@export var type: SOUND_EFFECT_TYPE
@export var sound_effect: AudioStream
@export_range(-40, 20) var volume: float = 0
@export_range(0.0, 4.0, 0.01) var pitch_scale: float = 1.0
@export_range(0.0, 1.0, 0.01) var pitch_randomness: float = 0.0
@export var bus: String = "Sounds" # по умолчанию Master

var audio_count: int = 0

func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)

func has_open_limit() -> bool:
	return audio_count < limit

func on_audio_finished() -> void:
	change_audio_count(-1)
