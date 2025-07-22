extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var buffer_timer: Timer = $BufferTimer
@onready var candycane: Area2D = $candycane
@onready var anim_player = candycane.get_node("AnimationPlayer")
@onready var attack: Timer = $Attack
@onready var cooldown_crit: Timer = $CooldownCrit
@onready var _player_animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_timer: Timer = $DamageTimer

enum PlayerState { IDLE, RUN, JUMP, ATTACK, HIT }
var current_state = PlayerState.IDLE

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var is_crit = false
var is_attacking = false
var is_damaged = false
var friction = 500.0
var knockback = Vector2.ZERO
var knockback_toggle = false
var knockback_timer = 0.0
var flash_in_progress = false

var health = 150

func _process(delta: float) -> void:
	
	set_animation()
#ATTACKING
	if Input.is_action_just_pressed("b_attack"):
		current_state = PlayerState.ATTACK
		is_crit = false
		is_attacking = true
		if sprite_2d.flip_h == false:
			anim_player.play("b_attack_right")
		if sprite_2d.flip_h == true:
			anim_player.play("b_attack_left")
		attack.start()

		
	if Input.is_action_just_pressed("c_attack") and cooldown_crit.is_stopped():
		current_state = PlayerState.ATTACK
		is_crit = true
		is_attacking = true
		if sprite_2d.flip_h == false:
			anim_player.play("c_attack_right")
		if sprite_2d.flip_h == true:
			anim_player.play("c_attack_left")
		attack.start()
		cooldown_crit.start()
		
	if health <= 0:
		queue_free()

func _on_attack_timeout() -> void:
	is_attacking = false
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
		current_state = PlayerState.JUMP
		velocity.y = JUMP_VELOCITY
		buffer_timer.stop()
		coyote_timer.stop()


	if knockback_toggle == false: #move when knockback is not enabled
		if direction:
			velocity.x = direction * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			
		if not is_attacking and not is_damaged:
			current_state = PlayerState.IDLE		
			#direction flipping
		if direction == 1 and is_attacking == false:
			sprite_2d.flip_h = false
			anim_player.play("idle_right")
		if direction == -1 and is_attacking == false:
			sprite_2d.flip_h = true
			anim_player.play("idle_left")
	elif knockback_toggle == true:
		direction = 0 #no moving when knockback is enabled
		current_state = PlayerState.IDLE
	move_and_slide()
		
	
func _knockback(enemyPosition: Vector2):
	var knockbackDirection = (global_position - enemyPosition).normalized() #same idea asin enemy script with direction
	knockback.x = knockbackDirection.x * 100 #not setting velocity here becaause that is abad idea
	knockback_timer = 0.2 #how long knockback will last

	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "hitbox":
		_knockback(area.get_parent().position)
		print("collided")

func _on_enemy_damage_output(damage_output) -> void: #take_damage function for player basically
	if is_damaged:
		return 
	
	is_damaged = true
	damage_timer.start()
	flash()
	health = health - damage_output
	
	
func set_animation():
	if current_state == PlayerState.HIT:
		_player_animation_player.play("hit")
		
	if current_state == PlayerState.JUMP:
		_player_animation_player.play("jump")
		
	if current_state == PlayerState.IDLE:
		_player_animation_player.play("idle")
		
	if current_state == PlayerState.RUN:
		_player_animation_player.play("run")
	
func flash():
	if flash_in_progress:
		return 
	flash_in_progress = true
	
	_player_animation_player.play("hit")
	
	flash_in_progress = false

func _on_damage_timer_timeout() -> void:
	is_damaged = false
	
