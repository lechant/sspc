extends Resource

var json_reader = preload("res://controller/Json_reader.tres")

var data = null

func load_data():
	if !data:
		data = json_reader.read_json("res://data/abilities_data.json")
	
func get_character_abilities(name):
	load_data()
	var abilities = []
	for tree in data[name]['trees']:
		abilities.append_array(data[name]['trees'][tree])
	return abilities
	
func get_ability_data(name,ability):
	load_data()
	for tree in data[name]['trees']:
		for skill in data[name]['trees'][tree]:
			if skill['name'] == ability:
				return skill 
				
func get_selection_param(name,ability):
	var ability_data = get_ability_data(name,ability)
	if ability_data.has('selection'):
		return ability_data['selection']
	else:
		return false
