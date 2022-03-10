extends BasePlayer

func skill_zombies(targets):
	print(targets)
	#get_unit_manager()
	
func skill_specters(targets):
	for x in targets:
		x.damage(2)
	state = IDLE
	
func skill_abomination(targets):
	for x in targets:
		x.status.push_back({"name":"poison","duration":4,"strength":3,"event":["turn_start"]})
