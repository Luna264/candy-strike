extends CharacterBody2D

@onready var alive_timer: Timer = $AliveTimer


func _physics_process(delta):
	move_and_slide()


func _on_alive_timer_timeout() -> void:
	queue_free()
