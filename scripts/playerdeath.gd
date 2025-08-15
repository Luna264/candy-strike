extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wait: Timer = $wait
@onready var retry: CanvasLayer = %retry
var playing = false
@onready var wahwah: AudioStreamPlayer2D = $wahwah
var sound_played = false

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if retry.visible == false:
		return
	if retry.visible == true and playing == false:
		animation_player.play("playerfall")
		playing = true
	if sound_played == false:
		wahwah.play()
		sound_played = true
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "playerfall":
		animation_player.play("loop")
		
