extends CharacterBody2D

@onready var alive_timer: Timer = $AliveTimer
@onready var player = get_tree().get_first_node_in_group("player")

signal damage_output

func _physics_process(delta):
	move_and_slide()


func _on_alive_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 0.5)

func _ready() -> void:
	if player:
		damage_output.connect(player._on_bullet_damage_output)
