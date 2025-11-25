extends HBoxContainer

@onready var unit_counter: Label = $VBoxContainer/UnitCounter
@onready var unit_manager: Node = $"../../../UnitManager"

func _ready() -> void:
	if unit_manager:
		unit_manager.connect("units_changed", Callable(self, "_on_units_changed"))
	_update_unit_counter(unit_manager.get_active(), unit_manager.get_reserved())

func _on_units_changed(units_active: int, units_reserved: int, units_total: int) -> void:
	_update_unit_counter(units_active, units_reserved)

func _update_unit_counter(units_active: int, units_reserved: int):
	var units_total = units_active + units_reserved
	unit_counter.text = "%d/%d/%d" % [units_active, units_reserved,units_total]
