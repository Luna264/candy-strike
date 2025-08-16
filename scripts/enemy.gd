extends CharacterBody2D

var health = 30
@export var speed = -80.0
@onready var player = get_tree().get_first_node_in_group("player")
var friction = 500.0
var damageoutput = 150
var knockback_x_jump = 200
var knockback_y_jump = -200

@onready var jump_timer: Timer = $JumpTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_timer: Timer = $DamageTimer
@onready var die_sound: AudioStreamPlayer2D = %Die
@onready var die_timer: Timer = $DieTimer
@onready var sprite_2d: Sprite2D = $Marshmellowslime

var dead = false
var is_attacking = false
var is_damaged = false
var flash_in_progress = false

signal damage_output
signal shakescreen

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()
	jump_timer.start(randi_range(1,3))

func _process(delta: float) -> void:
	if dead:
		return

	if is_damaged or flash_in_progress:
		update_animation("hit")
	elif is_attacking:
		update_animation("jump")
	else:
		update_animation("idle")

	if health <= 0 and not dead:
		get_tree().call_group("level", "enemy_death")
		die()

func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	if is_damaged or flash_in_progress:
		return

	shakescreen.emit()
	is_damaged = true
	flash_in_progress = true
	damage_timer.start()
	health -= dmg

	var direction = (global_position - attacker_position).normalized()
	velocity.x = direction.x * knockback_x
	velocity.y = knockback_y

func take_damage_explode(dmg, attacker_position, knockback_x, knockback_y):
	take_damage(dmg, attacker_position, knockback_x, knockback_y)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 4)

func _slime_jump() -> void:
	if is_attacking or is_damaged or flash_in_progress:
		return
	is_attacking = true
	face_player()
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * knockback_x_jump
	velocity.y = knockback_y_jump
	attack_timer.start()

func _on_jump_timer_timeout() -> void:
	if player and not flash_in_progress:
		_slime_jump()

func face_player():
	if player:
		sprite_2d.flip_h = player.global_position.x > global_position.x

func _on_attack_timer_timeout() -> void:
	is_attacking = false

func _on_damage_timer_timeout() -> void:
	is_damaged = false
	flash_in_progress = false

func flash():
	if flash_in_progress:
		return
	flash_in_progress = true

func die():
	if dead:
		return
	dead = true
	update_animation("dead")
	die_sound.play()
	die_timer.start()

func _on_die_timer_timeout() -> void:
	queue_free()

func update_animation(animation):
	animation_player.play(animation)
