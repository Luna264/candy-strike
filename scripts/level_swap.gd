extends Area2D

signal nextLevel

var is_active = false
var is_starting = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var current_animation = ""
@onready var level_manager: Node2D = %LevelManager

func _process(delta: float) -> void:
	if level_manager.totalDeaths >= 30 and not level_manager.level_over and level_manager.level_now == "Level1":
		is_active = true
		
	if level_manager.totalDeaths >= 34 and not level_manager.level_over and level_manager.level_now == "Level2":
		is_active = true
		
	if level_manager.totalDeaths >= 80 and not level_manager.level_over and level_manager.level_now == "Level3":
		is_active = true
		
			
	if is_active == false:
		animation_player.play("inactive")

		
	if is_active == true:
		animation_player.play("active")


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = "res://levels/level_" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
	
