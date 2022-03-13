extends BaseEnemy
	
func _ready():
	var priority_list = create_unit_priority_list()
	print(priority_list)
	print(create_area_priority_list(priority_list[0]['unit_pos'],1))

func turn_actions():
	pass
