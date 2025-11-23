extends Node2D

func _on_destination_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("carryable"):
		body.queue_free()
