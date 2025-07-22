extends Area2D
@onready var player = get_parent()

var dmg = 0
var knock_x = 0
var knock_y = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func hit(delta: float) -> void:
	if player.is_crit == false:
		dmg = 10	
		knock_x = 200
		knock_y = -200
		
		
	if player.is_crit == true:
		dmg = 25
		knock_x = 350
		knock_y = -350
		
		
	var overlapping = get_overlapping_bodies()
	print("Overlapping bodies: ", overlapping)
	
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(dmg, global_position, knock_x, knock_y) #passing in candy cane global position which enemy takes as attacker_position
