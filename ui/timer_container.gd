extends HBoxContainer

signal time_sent(time: float)

@onready var minutes_label: Label = $Minutes
@onready var seconds_label: Label = $Seconds
@onready var milliseconds_label: Label = $Milliseconds

var elapsed_time := 0.0
var minutes := 0
var seconds := 0
var milliseconds := 0

func _ready() -> void:
	Global.connect("all_interactables_collected", Callable(self, "_on_all_interactables_connected"))
	
func _process(delta: float) -> void:
	elapsed_time += delta
	# Calculate minutes: total seconds mod 3600 (1 hour) divided by 60
	minutes = fmod(elapsed_time, 3600) / 60
	# Calculate seconds: remainder of total seconds after removing full minutes
	seconds = fmod(elapsed_time, 60)
	# Calculate milliseconds: fraction of the current second times 1000
	milliseconds = fmod(elapsed_time, 1) * 1000
	
	minutes_label.text = "%02d:" % minutes
	seconds_label.text = "%02d." % seconds
	milliseconds_label.text = "%03d" % milliseconds

func _on_all_coins_connected():
	var level_name = get_tree().current_scene.name
	emit_signal("time_sent", elapsed_time)
