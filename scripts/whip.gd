extends CharacterBody2D

var health = 30
@export var speed = -80.0
@onready var player = get_tree().get_first_node_in_group("player")
var friction = 500.0
var damageoutput = 150
var knockback_x_jump = 200
var knockback_y_jump = -200

@onready var sprite_2d: Sprite2D = $Orb
@onready var damage_timer: Timer = $DamageTimer
@onready var die_timer: Timer = $DieTimer
@onready var die_sound: AudioStreamPlayer2D = %Die
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var is_damaged = false
var flash_in_progress = false
var dead = false

signal damage_output
signal shakescreen

func _ready() -> void:
	if player and not damage_output.is_connected(player._on_base_damage_output):
		damage_output.connect(player._on_base_damage_output)
	sprite_2d.material = sprite_2d.material.duplicate()
	animation_player.play("idle")

func _process(delta: float) -> void:
	if not is_damaged and not flash_in_progress and not dead:
		animation_player.play("idle")
		
	if health <= 0:
		print("enemy dead")
		get_tree().call_group("level", "enemy_death")
		die()


func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	damage_timer.start()
	emit_signal("shakescreen")
	if is_damaged or flash_in_progress:
		return
	
	is_damaged = true
	flash()
	health -= dmg




func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 0.3)


	
func _on_damage_timer_timeout() -> void:
	is_damaged = false
	flash_in_progress = false

func flash():
	if flash_in_progress:
		return
	animation_player.play("hit")
	flash_in_progress = true
	is_damaged = true
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		flash_in_progress = false
		
func die():
	if dead:
		return
	dead = true
	animation_player.play("dead")
	die_sound.play()
	die_timer.start()

func _on_die_timer_timeout() -> void:
	queue_free()
