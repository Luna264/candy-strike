extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check

signal levelSwap
var level_over = false

@onready var level_now = get_tree().current_scene.name


func _on_check_timeout() -> void:
	print("TOTALDEATHS: ", totalDeaths)
	if totalDeaths >= 30 and not level_over and level_now == "Level_1":
		if level_over == true:
			return
		else:
			emit_signal("levelSwap")
