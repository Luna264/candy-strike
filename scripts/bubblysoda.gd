extends Area2D

var floatAmount = -200
var active = false
@onready var cooldown_timer: Timer = $"../CooldownTimer"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
			body.velocity.x = floatAmount

func update_animation(animation):
	animation_player.play(animation)

func _on_cooldown_timer_timeout() -> void:
	active = !active 
	update_animation("on" if active else "off")
