extends Area2D

@export var speed = -80.0
@export var whipBase : Node2D 
@onready var player = get_tree().get_first_node_in_group("player")
var friction = 500.0
var damageoutput = 150
var knockback_x_jump = 200
var knockback_y_jump = -200


@onready var detection: Area2D = $detection
@onready var whip_animation_player: AnimationPlayer = %WhipAnimationPlayer

var is_attacking = false
var flash_in_progress = false

signal damage_output
signal shakescreen

func _ready() -> void:
	if player and not damage_output.is_connected(player._on_whip_damage_output):
		damage_output.connect(player._on_whip_damage_output)
	whip_animation_player.play("idle")

func _on_detection_attack() -> void:
	whip_animation_player.play("attack")


func _on_detection_stop_attack() -> void:
	whip_animation_player.play("idle")


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 0.3)
