extends CharacterBody2D

var health = 10
@export var speed = 80.0
@onready var player = get_tree().get_first_node_in_group("player")
var friction = 500.0
var damageoutput = 150
var knockback_x_jump = 200
var knockback_y_jump = -200


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_timer: Timer = $DamageTimer
@onready var shoot_timer: Timer = $ShootTimer
@export var bullet_scene: PackedScene
@onready var attack_timer: Timer = $AttackTimer
@onready var die_sound: AudioStreamPlayer2D = %Die
@onready var die_timer: Timer = $DieTimer
@onready var sprite_2d: Sprite2D = $Cloud
var spawner = null

var is_attacking = false
var is_damaged = false
var flash_in_progress = false
var dead = false

signal damage_output
signal shakescreen

func _ready() -> void:
	randomize()
	var speed = randf_range(10, 100)
	sprite_2d.material = sprite_2d.material.duplicate()


func _process(delta: float) -> void:
	if not is_attacking and not is_damaged and not flash_in_progress and not dead:
		animation_player.play("idle")
		sprite_2d.frame = 0

	if health <= 0 and not dead:
		spawner.enemy_death()
		die()


func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	emit_signal("shakescreen")
	if is_damaged:
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
	if not is_damaged:
		if player:
			if is_on_floor():
				velocity.y = -300
		
			var direction = (player.global_position - global_position)
			var distance = direction.length()

			if distance > 90:
				velocity = direction.normalized() * speed
		
			elif distance < 70:
				velocity = direction.normalized() * -speed
		
			else:
				velocity = Vector2.ZERO 
				
			
			
		move_and_slide()
		face_player()








func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 10)

func face_player():
	if player:
		sprite_2d.flip_h = player.global_position.x > global_position.x




func flash():
	if flash_in_progress:
		return 
	flash_in_progress = true
	
	animation_player.play("hit")



func _on_damage_timer_timeout() -> void:
	is_damaged = false
	flash_in_progress = false

func shoot():
	randomize()
	speed = randf_range(-1, 100)
	
	if player:
		if flash_in_progress:
			return
		if is_attacking:
			return
		if dead:
			return
		is_attacking = true
		sprite_2d.frame = 1
		attack_timer.start()
		
		
		
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		if player and not bullet.damage_output.is_connected(player._on_bullet_damage_output):
			bullet.damage_output.connect(player._on_bullet_damage_output)

		var direction = (player.global_position - global_position).normalized()
		bullet.velocity = direction * 100
		
		randomize()
		var size = randf_range(0.7, 1.5)
		bullet.scale = Vector2(size, size)
		
		
		
	
func die():
	if dead:
		return
	dead = true
	die_sound.play()
	animation_player.play("dead")
	die_timer.start()


func _on_die_timer_timeout() -> void:
	queue_free()

func _on_shoot_timer_timeout() -> void:
	shoot()
	


func _on_attack_timer_timeout() -> void: 
	is_attacking = false
	is_damaged = false
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		flash_in_progress = false
		is_damaged = false
