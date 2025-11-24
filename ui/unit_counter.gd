extends HBoxContainer

@onready var unit_counter: Label = $UnitCounter

var units_active: int
var units_reserved: int
var units_total: int

func _process(delta: float) -> void:
	_update_unit_counter()

func _update_unit_counter():
	units_active = get_tree().get_nodes_in_group("units").size()
	# todo make these work
	units_reserved = get_tree().get_nodes_in_group("units").size()
	units_total = units_active + units_reserved
	unit_counter.text = "%d/%d/%d" % [units_active, units_reserved,units_total]
