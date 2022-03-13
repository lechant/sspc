extends BaseEnemy

func turn_actions():
	if !alert:
		return
	var unit_priority = create_unit_priority_list()
	var area_priority = create_area_priority_list(unit_priority[0]['unit_pos'],1)
	#print(area_priority[0])
	move_to_point(area_priority[0]['position'])
