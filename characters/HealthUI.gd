extends VBoxContainer

onready var health_tween = $HealthBar/Tween
onready var health_bar_over = $HealthBar/HealthBarOver
onready var health_bar_under = $HealthBar/HealthBarUnder
onready var status_container = $StatusContainer
onready var unit = $"../../../Unit"

onready var status_rect = preload("res://StatusTextureRect.tscn")

var max_health = 0 setget _set_max_health

func _get_health_percentage(health):
	return health/max_health * 100
	
func _set_max_health(val):
	_assign_color(val)
	max_health = val
	
func set_status():
	for child in status_container.get_children():
		child.queue_free()
	for status in unit.status:
		#var new_status = TextureRect.new()
		var new_status = status_rect.instance()
		var img = Image.new()
		var tex = ImageTexture.new()
		img.load("res://assets/status_icons/poison.png")
		tex.create_from_image(img,0)
		new_status.texture = tex
		status_container.add_child(new_status)
	#put a placeholder if status is empty
	if !unit.status:
		var new_status = status_rect.instance()
		status_container.add_child(new_status)

func set_health(health):
	health = _get_health_percentage(health)
	health_bar_over.value = health
	#health_tween.interpolate_property(health_bar_under,"value",health_bar_under.value,health,0.55,Tween.TRANS_SINE, Tween.EASE_IN_OUT,0.15)
	health_tween.interpolate_property(health_bar_under,"value",health_bar_under.value,health,0.55,Tween.TRANS_SINE, Tween.EASE_IN_OUT,0.15)
	health_tween.start()
	
	_assign_color(health)
	
func _assign_color(health):
	if health < health_bar_over.max_value * 0.2:
		health_bar_over.tint_progress = Color.orange
	elif health < health_bar_over.max_value * 0.5:
		health_bar_over.tint_progress = Color.yellow
	else:
		health_bar_over.tint_progress = Color.lime
