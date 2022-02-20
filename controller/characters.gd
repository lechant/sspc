class_name Characters
extends Resource

export var character_data := {
	"charA" : {
		"move_range" : 3,
		"health" : 4,
		"action_points" : 8,
		"reach" : 4 
	},
	"charB" : {
		"move_range" : 5,
		"health" : 4,
		"action_points" : 6,
		"reach" : 1
	}
}
	
func get_data(character):
	return character_data[character]
	
func get_move_range(character):
	return character_data[character]["move_range"]
