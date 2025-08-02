extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check

signal levelSwap

func _on_check_timeout() -> void:
	if totalDeaths >= 2:
		emit_signal("levelSwapa")
		print("levelover, from level manager")
