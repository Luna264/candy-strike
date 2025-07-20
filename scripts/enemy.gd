extends CharacterBody2D

var health = 50

func _process(delta: float) -> void:
	if health < 0:
		print("dead at under 0")
		queue_free()
		
	if health == 0:
		print("dead at 0")
		queue_free()
		
func take_damage(dmg):
	health = health - dmg
	print(health)
