extends AudioStreamPlayer

const MUSIC_TRACKS = [
	preload("res://assets/music/BC 339 Submerged Castle (Olimar _ Louie _ President Shacho) .mp3"),
	preload("res://assets/music/BC 352 Wistful Wild (Olimar) .mp3"),
	preload("res://assets/music/BC 022 Valley of Repose (Olimar) .mp3"),
	preload("res://assets/music/BC 161 Perplexing Pool (Olimar) .mp3"),
	preload("res://assets/music/36 - BIT ROOTS.mp3"),
	preload("res://assets/music/35 - GLACEIR.mp3"),
	preload("res://assets/music/BC 080 Awakening Wood (Olimar) .mp3"),
	preload("res://assets/music/BC 08. The Forest Navel.mp3"),
	preload("res://assets/music/BC 09. The Distant Spring.mp3"),
]

var playlist = []
var current_index = 0

func _ready():
	randomize()
	_shuffle_playlist()
	finished.connect(Callable(self, "_on_finished"))
	_play_current()

func _shuffle_playlist():
	playlist = MUSIC_TRACKS.duplicate()
	playlist.shuffle()
	current_index = 0

func _play_current():
	stream = playlist[current_index]
	play()

func _on_finished():
	current_index += 1
	if current_index >= playlist.size():
		_shuffle_playlist()
	_play_current()
