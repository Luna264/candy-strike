extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check

signal levelSwap
var level_over = false

func _on_check_timeout() -> void:
	print("TOTALDEATHS: ", totalDeaths)
	if totalDeaths >= 4 and not level_over:
		if level_over == true:
			return
		else:
			emit_signal("levelSwap")
