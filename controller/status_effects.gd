extends Resource

func apply_status(target,event):
	var new_status_array = []
	for status in target.status:
		if status.event.has(event) && self.has_method(status.name):
			var new_status = call(status.name,target,status)
			if status.duration > 0:
				new_status_array.push_back(new_status)
		else:
			new_status_array.push_back(status)
	return new_status_array

func poison(target,status):
	target['curr_stats']['health'] -= status.strength
	status.duration -= 1
	return status
	
func stun(target,status):
	target['curr_stats']['health'] -= status.strength
	status.duration -= 1
	return status
	
func root(target,status):
	target['curr_stats']['move_range'] = 0
	status.duration -= 1
	return status
	
func bleed(target,status):
	target['curr_stats']['health'] -= status.strength
	status.duration -= 1
	return status
	
func reset_stats(target,stats_name):
	if target['curr_stats'].has(stats_name):
		target['curr_stats'][stats_name] = target['base_stats'][stats_name]
	pass
	
