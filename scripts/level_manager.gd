extends Node2D


@onready var totalDeaths = 0
@onready var check: Timer = $Check

signal levelSwap
var level_over = false
var max = 0
@onready var level_swap: Area2D = %LevelSwap

@onready var level_now = get_tree().current_scene.name
@onready var totaldeaths: Label = %TOTALDEATHS

func _ready() -> void:
	pass

func _on_check_timeout() -> void:
	
	if get_tree().current_scene.scene_file_path == "res://levels/level_1.tscn":
		max = 28
	
	if get_tree().current_scene.scene_file_path == "res://levels/level_2.tscn":
		max = 34
	
	if get_tree().current_scene.scene_file_path == "res://levels/level_3.tscn":
		max = 83
	
	if totaldeaths:
		totaldeaths.text = str(totalDeaths) + " out of " + str(max) + " enemies killed"
	
	level_now = get_tree().current_scene.name
	print("TOTALDEATHS: ", totalDeaths)
	print(get_tree().current_scene.scene_file_path)
	if totalDeaths >= 28 and get_tree().current_scene.scene_file_path == "res://levels/level_1.tscn":
		level_swap.is_active = true
		level_over = true

	if totalDeaths >= 34 and 	get_tree().current_scene.scene_file_path == "res://levels/level_2.tscn":
		level_swap.is_active = true
		level_over = true

	if totalDeaths >= 83 and get_tree().current_scene.scene_file_path == "res://levels/level_3.tscn":
		print("LEVEL 3 is OVER")
		level_swap.is_active = true
		level_over = true
	
		
