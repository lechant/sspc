extends Node

onready var highlight_tiles = $"../TileHighlight"
onready var path_tiles = $"../Path"
onready var camera2D = $"../Camera2D"

#var for action select
var selected_action = null

var characters = preload("res://controller/characters.tres")
var turn_order = preload("res://controller/turn_order.tres")
var json_reader = preload("res://controller/Json_reader.tres")

enum {CHAR_PLACE,CHAR_SELECT,CHAR_ACTION}
var state = CHAR_PLACE

#var unit_scene = preload("res://characters/Unit.tscn")

var character_data

func _ready():
	character_data = json_reader.read_json("res://data/character_data.json")
	turn_order.add_to_queue("charA","player",Vector2(1,1))
	turn_order.add_to_queue("charB","player",Vector2(2,4))
	turn_order.add_to_queue("masked_orc","enemy",Vector2(3,12))
	#connect to all signals emitted by unit nodes
	for unit_node in turn_order.unit_list:
		var data = character_data[unit_node.id]
		var unit_scene = load("res://characters/%s.tscn"%data['scene_name'])
		var new_unit = unit_scene.instance()
		new_unit.initialize(unit_node.id,data)
		new_unit.connect("move_complete",self,"_on_Unit_move_complete")
		new_unit.position = path_tiles.map_to_world(unit_node.initial_coord)
		add_child(new_unit)
	#initialize character select
	#set_manager_state(CHAR_SELECT)
	next_turn()
	
func _input(event):
	#NOTE, implement based off turn queue, not just cycle units
	#var unit_node = get_active_unit()
	if state == CHAR_SELECT:
		if event.is_action_pressed("ui_up"):
			turn_order.cycle_unit_list("player",true)			
			#NOTE: can implement character highlight/opacity change here
			var unit = turn_order.cycle_unit_list("player",false)
			highlight_move_range(get_unit_by_id(unit['id']))
		if event.is_action_pressed("ui_down"):
			var id = turn_order.cycle_unit_list("player",false).id
			turn_order.set_active(id)
			print("active unit: " + str(id))
			state = CHAR_ACTION
	elif state == CHAR_ACTION:
		if event.is_action_pressed("ui_down"):
			turn_order.next()
			state = CHAR_SELECT
			
func next_turn():
	var queue_item = turn_order.get_queue_current()
	if queue_item.type == "player":
		set_manager_state(CHAR_SELECT)
			
func set_manager_state(val):
	print("state change to: " + str(val))
	if val == CHAR_SELECT:
		var unit = turn_order.cycle_unit_list("player",false) 
		highlight_move_range(get_unit_by_id(unit['id']))
	state = val
	
func get_unit_by_id(id):
	for unit_node in get_children():
		if unit_node.character_id == id:
			return unit_node
	return false
	
func highlight_move_range(unit):
	#note: change to be based off cycle unit
	highlight_tiles.movement_range(unit.position,character_data[unit.character_id]['move_range'])
	
#NOTE: end of refactoring till here, continue
		
func move_unit(destination,auto_breakoff = false):
	var current_position = path_tiles.world_to_map(get_active_unit().position)
	var tile_destination = path_tiles.world_to_map(destination)
	#prevent move if no point to move to
	if !path_tiles.get_used_cells().has(tile_destination):
		return false
	var path = path_tiles.get_astar_path(current_position,tile_destination)
	#dont go if there is no way to get there
	if !path:
		return false
	#prevent move if destination exceeds move range
	if character_data[turn_order.active_unit_id]['move_range'] < path.size():
		if auto_breakoff:
			path.resize(character_data[turn_order.active_unit_id]['move_range'])
		else:
			return false
	get_active_unit().move_start()
	#pathfollow has its own prespective on coordinates so we are modifying the path to fit in pathfollow's prespective 
	get_active_unit().move(path_tiles.map_path_to_world(path,get_active_unit().path_follow.global_position))
	return true
	
func handle_action_press():
	if selected_action == 3:
		turn_order.set_active(turn_order.cycle_unit_list("player",false).id)
		pass
	if selected_action == 4:
		turn_order.next()
		pass
	
func handle_click(mouse_position):
	if selected_action == 1:
		move_unit(Vector2(mouse_position.x,mouse_position.y))
	elif selected_action == 2:
		var target = get_targeted_unit(mouse_position)
		if target:
			target.damage(2)
	
func get_active_unit():
	for unit_node in get_children():
		if unit_node.character_id == turn_order.active_unit_id:
			return unit_node
	return false
	
func get_targeted_unit(position):
	var tile_pos = path_tiles.world_to_map(position)
	var world_pos = path_tiles.map_to_world(tile_pos)
	for unit_node in get_children():
		if unit_node.global_position == world_pos:
			return unit_node
	return false
	
func get_all_units(type = ""):
	var unit_arr = []
	if type:
		for unit_node in get_children():
			if unit_node.base_stats['type'] == type:
				unit_arr.push_back(unit_node)
	else:
		unit_arr = get_children()
	return unit_arr
	
func next_character():
	selected_action = null
	#turn_order.next()
	#note change to interpret type received instead of object
	if get_active_unit()['base_stats'].type == "enemy":
		get_active_unit().turn_actions()
		#next_character()
	highlight_move_range(get_active_unit())
		
func _on_Unit_move_complete():
	highlight_move_range(get_active_unit())
	get_active_unit().move_end()
