extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check

signal levelSwap
var level_over = false

func _on_check_timeout() -> void:
	if totalDeaths >= 1 and not level_over:
		if level_over == true:
			return
		else:
			emit_signal("levelSwap")
			var level_over = true
