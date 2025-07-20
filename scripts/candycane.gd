extends Area2D
@onready var player = get_parent()

var dmg = 0
func hit():
	if player.is_crit == false:
		dmg = 10	
		
	if player.is_crit == true:
		dmg = 25	
		
	var overlapping = get_overlapping_bodies()
	print("Overlapping bodies: ", overlapping)
	
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(dmg)
