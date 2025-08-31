extends Area2D

var floatAmount = 250
var active = false
@onready var cooldown_timer: Timer = $"../CooldownTimer"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var swoosh: AudioStreamPlayer2D = %Swoosh

func _ready() -> void:
	animation_player.play("on")
	
func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.soda_boost(Vector2(0, 400))
		if body.is_in_group("enemy"):
			body.velocity.x = floatAmount

#func update_animation(animation):
	#animation_player.play(animation)

#func _on_cooldown_timer_timeout() -> void:
	#active = !active 
	#update_animation("on" if active else "off")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy") and active == true:
		swoosh.play()
