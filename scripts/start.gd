extends Control

@onready var animation_player: AnimationPlayer = $MarginContainer/VBoxContainer/Button/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _on_button_pressed() -> void:
	animation_player.play("play")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "play":
		get_tree().change_scene_to_file("res://levels/level_1.tscn")
