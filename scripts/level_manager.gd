extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check

signal levelSwap
var level_over = false
@onready var level_swap: Area2D = %LevelSwap

@onready var level_now = get_tree().current_scene.name

func _on_check_timeout() -> void:
	level_now = get_tree().current_scene.name
	print("TOTALDEATHS: ", totalDeaths)
	print(level_now)
	if (totalDeaths >= 28) and (level_now == "Level1" or level_now == "Level_1"):
		level_swap.is_active = true
		level_over = true
		
	if (totalDeaths >= 34) and (level_now == "Level2" or level_now == "Level_2"):
		level_swap.is_active = true
		level_over = true
		
	if (totalDeaths >= 80) and (level_now == "Level3" or level_now == "Level_3"):
		level_swap.is_active = true
		level_over = true
		
