extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check


func _on_check_timeout() -> void:
	if totalDeaths >= 2:
		print("levelover, from level manager")
