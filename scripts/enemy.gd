extends CharacterBody2D

var health = 150
@export var speed = -80.0
@onready var player = get_tree().get_first_node_in_group("player")
var friction = 500.0
var damageoutput = 150
var knockback_x_jump = 200
var knockback_y_jump = -200

@onready var jump_timer: Timer = $JumpTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_timer: Timer = $DamageTimer

var is_attacking = false
var is_damaged = false
var flash_in_progress = false

signal damage_output
signal shakescreen

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()


func _process(delta: float) -> void:
	if not is_attacking and not is_damaged and not flash_in_progress:
		animation_player.play("idle")

	if health <= 0:
		print("enemy dead")
		queue_free()


func take_damage_explode(dmg, attacker_position, knockback_x, knockback_y):
	shakescreen.emit()
	if is_damaged:
		return 
	if flash_in_progress:
		return
	
	is_damaged = true
	damage_timer.start()
	flash()
	health -= dmg

	var direction = (global_position - attacker_position).normalized()
	velocity.x = direction.x * knockback_x
	velocity.y = knockback_y

func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	shakescreen.emit()
	if is_damaged:
		return 
	if flash_in_progress:
		return
	
	is_damaged = true
	damage_timer.start()
	flash()
	health -= dmg

#knockback
	var direction = (global_position - attacker_position).normalized()
	velocity.x = direction.x * knockback_x
	velocity.y = knockback_y


func _physics_process(delta):

	if not is_on_floor():
		velocity += get_gravity() * delta
	elif velocity.y > 0:
		velocity.y = 0 


	velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 10)


func _slime_jump() -> void:
	if flash_in_progress:
		return
	if is_attacking:
		return
	if is_damaged:
		return
	is_attacking = true
	face_player()
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * knockback_x_jump
	velocity.y = knockback_y_jump
	attack_timer.start()


func _on_jump_timer_timeout() -> void:
	if player:
		_slime_jump()


func face_player():
	if player:
		sprite_2d.flip_h = player.global_position.x < global_position.x


func _on_attack_timer_timeout() -> void:
	is_attacking = false
	flash_in_progress = false
	animation_player.play("RESET")
	
func _on_damage_timer_timeout() -> void:
	is_damaged = false
	flash_in_progress = false
	animation_player.play("RESET")

func flash():
	if flash_in_progress:
		return 
	flash_in_progress = true
	
	animation_player.play("hit")
	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		flash_in_progress = false
