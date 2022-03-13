extends Node

onready var highlight_tiles = $"../TileHighlight"
onready var path_tiles = $"../Path"
onready var camera2D = $"../Camera2D"

#var for action select
var selected_action = null

var turn_order = preload("res://controller/turn_order.tres")
var json_reader = preload("res://controller/Json_reader.tres")
var ability_data = preload("res://controller/ability_data.tres")
var target_selection = preload("res://controller/target_selection.tres")

var character_data

func _ready():
	character_data = json_reader.read_json("res://data/character_data.json")
	turn_order.add_to_queue("masked_orc",4,Vector2(3,12))
	turn_order.add_to_queue("slime",4,Vector2(2,5))
	turn_order.add_to_queue("summoner",5,Vector2(1,1))
	#connect to all signals emitted by unit nodes
	for unit_data in turn_order.turn_queue:
		var data = character_data[unit_data.id]
		var unit_scene = load("res://characters/%s.tscn"%data['scene_name'])
		var new_unit = unit_scene.instance()
		new_unit.initialize(unit_data.id,data)
		new_unit.connect("move_complete",self,"_on_Unit_move_complete")
		new_unit.position = path_tiles.map_to_world(unit_data.initial_coord)
		add_child(new_unit)
	highlight_move_range()
	
func _input(event):
	var unit_node = get_active_unit()
	if event.is_action_pressed("ui_click"):
		var mouse_position = camera2D.get_global_mouse_position()
		if unit_node.is_idle():
			handle_click(mouse_position)
		if unit_node.is_skill():
			target_selection.add_selection(mouse_position)
	elif event.is_action_pressed("ui_up") && unit_node.is_idle():
		unit_node.end_turn()
		next_character()
		unit_node.start_turn()
	elif event.is_action_pressed("ui_interact") && unit_node.is_idle():
		var overlap_areas = unit_node.get_overlapping_areas()
		if overlap_areas:
			overlap_areas[0].interact(unit_node)
	elif event.is_action_pressed("ui_num"):
		selected_action = event.scancode - 48
		handle_num_action(selected_action)
		
func move_unit(destination,auto_breakoff = false):
	var path = find_unit_path_to(get_active_unit(),destination)
	#prevent move if destination exceeds move range
	if !path:
		return false
	if character_data[turn_order.get_current().id]['move_range'] < path.size():
		if auto_breakoff:
			path.resize(character_data[turn_order.get_current().id]['move_range'])
		else:
			return false
	get_active_unit().move_start()
	#pathfollow has its own prespective on coordinates so we are modifying the path to fit in pathfollow's prespective 
	get_active_unit().move(path_tiles.map_path_to_world(path,get_active_unit().path_follow.global_position))
	path_tiles.enable_disabled_points()
	return true
	
func handle_click(mouse_position):
	if selected_action == 1:
		move_unit(Vector2(mouse_position.x,mouse_position.y))
	elif selected_action == 2:
		var target = get_unit_at_position(mouse_position)
		if target:
			target.damage(2)
	elif selected_action == 3:
		pass
			
func handle_num_action(numkey):
	pass
	
func get_active_unit():
	for unit_node in get_children():
		if unit_node.character_id == turn_order.get_current().id:
			return unit_node
	return false
	
func get_unit_at_position(position):
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
	
func highlight_move_range():
	highlight_tiles.radial_highlight(get_active_unit().position,character_data[turn_order.get_current().id]['move_range'])
	
func next_character():
	selected_action = null
	turn_order.next()
	if get_active_unit()['base_stats'].type == "enemy":
		get_active_unit().turn_actions()
		#next_character()
	highlight_move_range()
	
func find_unit_path_to(unit,destination):
	var current_position = path_tiles.world_to_map(get_active_unit().position)
	var tile_destination = path_tiles.world_to_map(destination)
	for unit in get_all_units():
		var unit_position = path_tiles.world_to_map(unit.global_position)
		path_tiles.set_point_disabled(unit_position)
	#prevent move if no point to move to
	if !path_tiles.get_used_cells().has(tile_destination):
		return false
	var path = path_tiles.get_astar_path(current_position,tile_destination)
	return path
		
func _on_Unit_move_complete():
	highlight_move_range()
	get_active_unit().move_end()

func _on_CombatMenu_skill_select(name):
	print("skill selected:" + name + " from unit" + get_active_unit().character_id)
	get_active_unit().on_skill_use(1)
	target_selection.set_skill(self,get_active_unit().global_position,name)

func selection_callback(selection_data):
	var func_name = "skill_" + target_selection.active_skill.to_lower()
	if get_active_unit().has_method(func_name):
		get_active_unit().call(func_name,selection_data)
