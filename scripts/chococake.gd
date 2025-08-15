extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
var speed = 50
@onready var sprite_2d: Sprite2D = $Sprite2D

signal damage_output
signal explode
signal shakescreen

var is_attacking = false
var is_damaged = false
var flash_in_progress = false
var health = 150

var explode_timer = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_timer: Timer = $DamageTimer
@onready var detector: Area2D = $detector
var first_stage = false
var is_exploding = false
var second_stage = false
var is_jumping = false
@onready var jump_timer: Timer = $JumpTimer

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
		animation_player.play("RESET")

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
		emit_signal("damage_output", 10)
		

func _process(delta: float) -> void:
	print("Current animation:", animation_player.current_animation)
	if not is_attacking and not is_damaged and not flash_in_progress and not is_exploding and not second_stage and not first_stage:
		animation_player.play("idle")

	if health <= 0:
		print("enemy dead")
		get_tree().call_group("level", "enemy_death")
		queue_free()
	
	if detector.player_is == true:
		explode_timer += delta
		first_stage = true
		
	elif detector.player_is == false:
		first_stage = false
		explode_timer = 0.5
	else:
		explode_timer = max(0, explode_timer - delta)
		
	if first_stage == true and not second_stage and not is_exploding:
		animation_player.play("blow1")
		
	if explode_timer > 1 and not is_exploding:
		first_stage = false
		second_stage = true
		animation_player.play("blow2")
		
	if explode_timer > 2 and not is_exploding:
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
	is_damaged = false
	is_attacking = false
	first_stage = false
	second_stage = false
	animation_player.play("explode")

func _on_jump_timer_timeout() -> void:
	var direction = (player.global_position - global_position).normalized()
	is_jumping = true
	velocity.y = -350 
	velocity.x += 20 * direction.x
	jump_timer.start()
	is_jumping = false
