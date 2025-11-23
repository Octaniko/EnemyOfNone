extends Label

func _ready() -> void:
	Global.connect("interactables_updated", Callable(self, "_on_interactables_updated"))

func _on_interactables_updated(interactables_collected, interactables_total):
	text = "%02d" % interactables_collected + "/" + "%02d" % interactables_total
