extends Area2D

signal attack
var player_is = false
@onready var my_attack_timer: Timer = $AttackTimer
signal stopAttack

func _ready() -> void:
	pass


func _on_attack_timer_timeout() -> void:
	if player_is:
		emit_signal("attack")
		my_attack_timer.start()



func _on_area_exited(area: Area2D) -> void:
	player_is = false
	emit_signal("stopAttack")


func _on_area_entered(area: Area2D) -> void:
	emit_signal("attack")
	player_is = true
	my_attack_timer.start()
