extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_2d: Sprite2D = $Chococake

signal damage_output
signal explode
signal shakescreen


var speed = 50
var is_attacking = false
var is_damaged = false
var flash_in_progress = false
var health = 50
var dead = false
@onready var die_sound: AudioStreamPlayer2D = %Die
@onready var die_timer: Timer = $DieTimer

var explode_timer = 0.0
var current_anim = "idle"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_timer: Timer = $DamageTimer
@onready var detector: Area2D = $detector
var first_stage = false
var is_exploding = false
var second_stage = false
var is_jumping = false
@onready var jump_timer: Timer = $JumpTimer
var spawner = null


func _ready() -> void:
	animation_player.play("idle")
	if player:
		damage_output.connect(player._on_chococake_damage_output)
	randomize()
	speed = randf_range(30, 50)



func _physics_process(delta: float) -> void:
	if player:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if not is_damaged and not is_exploding and not is_jumping:
			var direction = (player.global_position - global_position).normalized()
			velocity.x = speed * direction.x
		face_player()
		
		move_and_slide()


func face_player():
	if player:
		sprite_2d.flip_h = player.global_position.x < global_position.x



	
func _on_damage_timer_timeout() -> void:
	if not is_exploding:
		is_damaged = false
		flash_in_progress = false
		animation_player.play("idle")

func flash():
	if flash_in_progress:
		return 
	flash_in_progress = true
	
	animation_player.play("hit")
	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		flash_in_progress = false
	if anim_name == "explode":
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 7)
		

func _process(delta: float) -> void:
	if not is_damaged and not flash_in_progress and not is_exploding and not detector.player_is and not dead:
		play_anim("idle")

	if health <= 0 and not dead:
		spawner.enemy_death()
		die()
	
	if detector.player_is == true:
		explode_timer += delta
		first_stage = true
		if not second_stage and not is_exploding and not dead:
			animation_player.play("blow1")
			
	elif detector.player_is == false:
		first_stage = false
	else:
		explode_timer = max(0, explode_timer - delta)
		
		
	if explode_timer > 1 and not is_exploding:
		first_stage = false
		second_stage = true
		if not first_stage and not is_exploding and not dead:
			animation_player.play("blow2")
			

		
	if explode_timer > 2 and not is_exploding and not dead:
		first_stage = false
		second_stage = false
		is_exploding = true
		emit_signal("explode")
		print("explode")
	

		
func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	if not is_exploding:
		emit_signal("shakescreen")
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
	


func _on_explode() -> void:
	spawner.enemy_death()
	is_damaged = false
	is_attacking = false
	first_stage = false
	second_stage = false
	animation_player.play("explode")

func _on_jump_timer_timeout() -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		is_jumping = true
		velocity.y = -350 
		velocity.x += 20 * direction.x
		jump_timer.start()
		is_jumping = false

func die():
	if dead:
		return
	dead = true
	animation_player.play("dead")
	die_sound.play()
	die_timer.start()


func _on_hitbox_explode_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		emit_signal("damage_output", 30)

func _on_die_timer_timeout() -> void:
	queue_free()
	

func play_anim(name):
	if current_anim == name:
		return
	current_anim = name
	animation_player.play(name)
