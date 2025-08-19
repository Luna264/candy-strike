extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@export var animation: String = ""  

	
func _process(delta: float) -> void:
	if animation_player.has_animation(animation):
		animation_player.play(animation)
