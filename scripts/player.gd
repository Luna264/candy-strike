extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
@onready var attack: Timer = $Attack
@onready var cooldown_crit: Timer = $CooldownCrit
@onready var hit_timer: Timer = $HitTimer

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var candycane: Area2D = $candycane

@onready var anim_player = candycane.get_node("AnimationPlayer")
@onready var _player_animation_player: AnimationPlayer = $AnimationPlayer

signal shakescreenplayer

var is_crit = false
var is_attacking = false
var is_damaged = false
var flash_in_progress = false

var friction = 500.0
const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var knockback = Vector2.ZERO
var knockback_toggle = false
var knockback_timer = 0.0

var health = 150


func _process(delta: float) -> void:
	
#ATTACKING
	if Input.is_action_just_pressed("b_attack"):
		if is_damaged == true:
			return
		else:
			is_crit = false
			is_attacking = true
			update_animation("attack")
			
			
			if not Input.get_axis("left", "right") == 0:
				if Input.get_axis("left", "right") < 0: # left
					sprite_2d.flip_h = true
				else:
					sprite_2d.flip_h = false # right
					
			if not sprite_2d.flip_h:
				anim_player.play("b_attack_right")
			else:
				anim_player.play("b_attack_left")
				
			attack.start()

		
	if Input.is_action_just_pressed("c_attack") and cooldown_crit.is_stopped():
		if is_damaged == true:
			return
		else:
			is_crit = true
			is_attacking = true
			update_animation("attack")
			
			if not Input.get_axis("left", "right") == 0:
				if Input.get_axis("left", "right") < 0: # left
					sprite_2d.flip_h = true
				else:
					sprite_2d.flip_h = false # right
		
			if not sprite_2d.flip_h:
				anim_player.play("c_attack_right")
			else:
				anim_player.play("c_attack_left")
			
			attack.start()
			cooldown_crit.start()
		
	if health <= 0:
		queue_free()

func _on_attack_timeout() -> void:
	is_attacking = false
	is_damaged = false
	update_animation("RESET")
	anim_player.play("RESET")

var was_on_floor = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	
	
	if knockback_timer > 0.0: #knockback enabled
		velocity.x = knockback.x
		knockback_timer -= delta
		knockback_toggle = true
		
	if knockback_timer <= 0.0: #no knockback 
		knockback = Vector2.ZERO
		knockback_toggle = false		
		
		
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	if was_on_floor and not is_on_floor() and velocity.y > 0:
		coyote_timer.start()
	was_on_floor = is_on_floor()
			
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		buffer_timer.start()
				
	if Input.is_action_just_pressed("jump") and is_on_floor() || Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped() ||  not buffer_timer.is_stopped() && is_on_floor():
		if is_attacking:
			is_attacking = false
			update_animation("run")
		
		velocity.y = JUMP_VELOCITY
		buffer_timer.stop()
		coyote_timer.stop()


	if knockback_toggle == false: #move when knockback is not enabled
		if direction and not is_damaged and not flash_in_progress:
			velocity.x = direction * SPEED
			if not is_attacking:
				update_animation("run") 
			if is_attacking:
				velocity.x = 0
			elif flash_in_progress:
				velocity.x = 0

			
		elif is_damaged == false and is_attacking == false:
			velocity.x = move_toward(velocity.x, 0, 900 * delta)
			update_animation("idle")
		

		if direction == 1 and is_attacking == false:
			sprite_2d.flip_h = false
			anim_player.play("idle_right")
		if direction == -1 and is_attacking == false:
			sprite_2d.flip_h = true
			anim_player.play("idle_left")
	elif knockback_toggle == true:
		direction = 0 #no moving when knockback is enabled
	move_and_slide()
		
	
func _knockback(enemyPosition: Vector2):
	var knockbackDirection = (global_position - enemyPosition).normalized() #same idea asin enemy script with direction
	knockback.x = knockbackDirection.x * 200 #not setting velocity here becaause that is abad idea
	knockback_timer = 0.2 #how long knockback will last

	
func _on_hurtbox_area_entered(area: Area2D) -> void:           #take damage player detection
	if area.name == "hitbox" or area.is_in_group("enemy"):
		emit_signal("shakescreenplayer")
		_knockback(area.get_parent().position)
		
		if is_attacking:
			return
			
		elif is_damaged:
			return	
			
		elif flash_in_progress:
			return
			
		else:
			is_damaged = true
			flash()
		hit_timer.start()		
		

func _on_enemy_damage_output(damage_output) -> void: #take_damage function for player basically
		
	is_attacking = false 
	is_damaged = true
	
	print("being attacked")
	health = health - damage_output


func update_animation(animation):
	_player_animation_player.play(animation)


func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "hit":
		is_damaged = false
		flash_in_progress = false
		update_animation("idle")

	if anim_name == "attack":
		is_attacking = false
		update_animation("idle")

func flash():
	if flash_in_progress or is_attacking:
		return
	flash_in_progress = true
	is_damaged = true
	update_animation("hit")

func _on_hit_timer_timeout() -> void:
	is_attacking = false
	is_damaged = false
	flash_in_progress = false


func _on_shakescreenplayer() -> void:
	pass # Replace with function body.
