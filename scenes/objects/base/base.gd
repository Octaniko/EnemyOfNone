extends Node2D

func _on_destination_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		var unit_manager = get_tree().get_nodes_in_group("unit_manager")[0]
		if body.is_in_group("emergency"):
			unit_manager.add_units_emergency()
		elif body.is_in_group("enemies"):
			unit_manager.add_units_enemy()
		else:
			Global.emit_signal("interactable_collected")
		body.queue_free()
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.DELIVERY)
