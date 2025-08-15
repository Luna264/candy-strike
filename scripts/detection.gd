extends Area2D

signal attack
var player_is = false
signal stopAttack
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	pass


func _on_attack_timer_timeout() -> void:
	if player_is:
		emit_signal("attack")
		attack_timer.start()



func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_is = false
		emit_signal("stopAttack")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		emit_signal("attack")
		player_is = true
		attack_timer.start()
