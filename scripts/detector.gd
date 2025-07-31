extends Area2D

signal attack
var player_is = false
signal stopAttack

func _ready() -> void:
	pass



func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_is = false
		emit_signal("stopAttack")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_is = true
		emit_signal("attack")
