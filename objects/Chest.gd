class_name Chest , "res://assets/chest3.png"
extends Interactive_Object

var floating_text = preload("res://objects/FloatingText.tscn")

#use this to display text above interactive object
func _on_Chest_area_entered(area):
	if !$FloatingText:
		var new_text = floating_text.instance()
		new_text.prompt_text(self,"Press E to interact with objects")

func _on_Chest_area_exited(area : Area2D):
	print("area exited")

func interact(unit):
	$AnimationPlayer.play("chest_open")
