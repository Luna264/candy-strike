extends Area2D

signal attack
var player_is = false
@onready var my_attack_timer: Timer = $AttackTimer

func _on_attack_timer_timeout() -> void:
	if player_is:
		print("lezduit")
		#hit


func _on_area_entered(area: Area2D) -> void:
	#hit
	print("lezduit")
	print("player entered")
	player_is = true
	my_attack_timer.start()


func _on_area_exited(area: Area2D) -> void:
	player_is = false
