extends AudioStreamPlayer

const MUSIC_TRACKS = [
	preload("res://assets/music/BC 339 Submerged Castle (Olimar _ Louie _ President Shacho) .mp3"),
	preload("res://assets/music/BC 352 Wistful Wild (Olimar) .mp3"),
	preload("res://assets/music/BC 022 Valley of Repose (Olimar) .mp3"),
	preload("res://assets/music/BC 161 Perplexing Pool (Olimar) .mp3"),
	preload("res://assets/music/36 - BIT ROOTS.mp3"),
	preload("res://assets/music/35 - GLACEIR.mp3")
	
]

func _ready():
	randomize()
	finished.connect(Callable(self, "_on_finished"))
	_play_random()

func _on_finished():
	_play_random()

func _play_random():
	var idx = randi() % MUSIC_TRACKS.size()
	stream = MUSIC_TRACKS[idx]
	play()
