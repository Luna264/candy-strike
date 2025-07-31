extends Area2D


var dmg = 30
var knock_x = 300
var knock_y = -400

func _process(delta: float) -> void:
	var overlapping = get_overlapping_bodies()
	print("Overlapping bodies: ", overlapping)
	
	for body in get_overlapping_bodies():
		if body.has_method("take_damage_explode"):
			body.take_damage_explode(dmg, global_position, knock_x, knock_y) #passing in candy cane global position which enemy takes as attacker_position
