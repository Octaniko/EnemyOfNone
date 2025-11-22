# todo: figure out how this works after setting everyting else up
extends State

@export var idle_state: State = null
@export var follow_state: State = null
@export var carry_speed := 100
@export var delivery_tolerance := 16.0
#@export var post_carry_check_delay := 0.1

var carry_object: Node2D = null
var base_node: Node2D = null
#var checking_timer = null

func enter() -> void:
	super()
	move_speed = carry_speed
	if parent.has_meta("carry_object"):
		carry_object = parent.get_meta("carry_object")
	else:
		carry_object = null
	
	var bases = get_tree().get_nodes_in_group("bases")
	if bases.size() > 0:
		base_node = bases[0]
		parent.navigation_agent_2d.target_position = base_node.global_position
	else:
		base_node = null
		parent.navigation_agent_2d.target_position = parent.global_position
	
	if carry_object and carry_object.has_method("on_carriers_started"):
		var carriers = carry_object.get_meta("carriers") if carry_object.has_meta("carriers") else []
		carry_object.call("on_carriers_started", carriers)

func process_physics(delta: float) -> State:
	if base_node == null:
		return follow_state
	
	parent.navigation_agent_2d.target_position = base_node.global_position
	
	if not parent.navigation_agent_2d.is_navigation_finished():
		var next_path_position = parent.navigation_agent_2d.get_next_path_position()
		var direction = (next_path_position - parent.global_position).normalized()
		parent.velocity = direction * move_speed
		parent.move_and_slide()
		parent.animations.flip_h = parent.velocity.x < 0
		return null
		
	if parent.global_position.distance_to(base_node.global_position) <= delivery_tolerance:
		_on_delivered()
	
		var t = parent.get_nearest_interactable()
		if t: 
			print("[Carry] after delivery: found interactable:", t)
			return follow_state
		else:
			print("[Carry] after delivery: no interactable nearby, go [Follow]")
			return follow_state
	if carry_object == null or not is_instance_valid(carry_object):
		return follow_state
	
	return null

func _on_delivered() -> void:
	if carry_object:
		if carry_object.has_method("on_delivered"):
			var carriers = carry_object.get_meta("carriers") if carry_object.has_meta("carriers") else []
			carry_object.call("on_delivered", carriers, base_node)
		if carry_object.has_meta("carriers"):
			carry_object.set_meta("carriers", [])
	parent.set_meta("carry_object", null)
