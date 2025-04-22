extends Area2D

func _ready():  # Assign fruit to group for easy detection
	add_to_group("fruit")
	print("Is object in 'fruit' group?", is_in_group("fruit"))
	print("Ant Collision Layer:", collision_layer, "Mask:", collision_mask)
	
func _on_Fruit_body_entered(area):  # Called when an ant collides with fruit
	if area.is_in_group("ant"):
		print("Ant picked up fruit!")
		queue_free()  # Remove fruit from scene
