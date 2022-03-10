class_name unit
extends Path2D

onready var path_follow = $PathFollow2D
onready var animation_player = $AnimationPlayer
onready var unit_area = $PathFollow2D/Area2D
onready var health_ui = $PathFollow2D/HealthUI
onready var sprite = $PathFollow2D/Sprite
onready var path_tiles = get_unit_manager().path_tiles

signal move_complete

enum {IDLE, MOVING, SKILL}

#var for on_move event
var path_points_length = 0
var path_point_counter = 0
var last_point = null

var status_effects = preload("res://controller/status_effects.tres")
var floating_text = preload("res://objects/FloatingText.tscn");

export var character_id = ""
export var base_stats = {}
export var curr_stats = {}

var state = IDLE
var status = []

var rng = RandomNumberGenerator.new()

func _ready():
	#animation_player.play("idle")
	curve = Curve2D.new()
	health_ui.max_health = base_stats['health']

func move(path):
	animation_player.play("moving")
	print("play moving animation")
	path_points_length = path.size()
	for point in path:
		curve.add_point(point)

func initialize(id,data):
	character_id = id
	base_stats = data
	curr_stats = data

func _process(delta):
	if path_follow.offset >= curve.get_baked_length() && curve.get_baked_points().size() > 0:
		position = path_follow.global_position
		path_follow.offset = 0.0
		curve.clear_points()
		#reset on_move event variable
		path_point_counter = 0
		animation_player.play("idle")
		emit_signal("move_complete")
	if curve.get_baked_points():
		var path_segment_size = curve.get_baked_length()/path_points_length
		if path_follow.offset > (path_point_counter + 1) * path_segment_size:
			path_point_counter += 1
			on_move()
		path_follow.offset += 65.0 * delta
		
func get_overlapping_areas():
	return unit_area.get_overlapping_areas()
	
func get_unit_manager():
	return get_parent()
	
func damage(val):
	var reduction = rng.randi_range(0,curr_stats.absorption)
	#damage text
	var damage_template = "[center][color=#FF2300]{dmg}[/color]-[img]res://assets/status_icons/tile161.png[/img][color=#87CEEB]{red}[/color][/center]"
	var new_text = floating_text.instance()
	new_text.damage_text(self,damage_template.format({'dmg':str(val),'red':str(reduction)}))
	animation_player.play("damage")
	curr_stats['health'] -= max(val - reduction,0)
	if curr_stats['health'] <= 0 :
		print("unit dead")
	health_ui.set_health(curr_stats['health'])
	yield(get_tree().create_timer(0.25), "timeout")
	animation_player.play("idle")
	
func heal(val):
	curr_stats['health'] += val
	
#unit getters
func is_moving():
	return state == MOVING

func is_idle():
	return state == IDLE
	
func is_skill():
	return state == SKILL
	
#unit events
func start_turn():
	status = status_effects.apply_status(self,"turn_start")
	print("start turn: " + character_id)
	pass

func end_turn():
	print("end turn: " + character_id)
	pass

func move_start():
	state = MOVING
	pass
	
func move_end():
	state = IDLE
	pass

func on_move():
	if last_point && global_position > last_point:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
	last_point = sprite.global_position
	status = status_effects.apply_status(self,"on_move")
	
func on_skill_use(val):
	state = SKILL
	print("skilluse event")
	return val
