extends Area2D

signal nextLevel

var is_active = false
var is_starting = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var swap: Timer = $Swap
var current_animation = ""


func _process(delta: float) -> void:
	
	if is_active:
		is_starting = false
	
	if is_active == false and is_starting == false:
		animation_player.play("inactive")

		
	if is_active == true and is_starting == false:
		animation_player.play("active")

		
	if is_active == false and is_starting == true:
		animation_player.play("alive")


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = "res://levels/level_" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)


func _on_level_manager_level_swap() -> void:
		is_starting = true
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "alive":
		is_starting = false
		is_active = true
