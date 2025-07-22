extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var buffer_timer: Timer = $BufferTimer
@onready var candycane: Area2D = $candycane
@onready var anim_player = candycane.get_node("AnimationPlayer")
@onready var attack: Timer = $Attack
@onready var cooldown_crit: Timer = $CooldownCrit

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var is_crit = false
var is_attacking = false
var friction = 200.0
var knockback = Vector2.ZERO
var knockback_toggle = false
var knockback_timer = 0.0

func _process(delta: float) -> void:
#ATTACKING
	if Input.is_action_just_pressed("b_attack"):
		is_crit = false
		is_attacking = true
		anim_player.play("attackbase")
		attack.start()
		
	if Input.is_action_just_pressed("c_attack") and cooldown_crit.is_stopped():
		is_crit = true
		is_attacking = true
		anim_player.play("attackcrit")
		attack.start()
		cooldown_crit.start()
		

func _on_attack_timeout() -> void:
	is_attacking = false
	anim_player.play("RESET")

var was_on_floor = false

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0: #knockback enabled
		velocity.x = knockback.x
		knockback_timer -= delta
		set_process_input(false)
	if knockback_timer <= 0.0: #no knockback 
		knockback = Vector2.ZERO		
		set_process_input(true)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if was_on_floor and not is_on_floor() and velocity.y > 0:
		coyote_timer.start()
	was_on_floor = is_on_floor()
		
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		buffer_timer.start()
			
	if Input.is_action_just_pressed("jump") and is_on_floor() || Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped() ||  not buffer_timer.is_stopped() && is_on_floor():
		velocity.y = JUMP_VELOCITY
		buffer_timer.stop()
		coyote_timer.stop()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		
		#direction flipping
	if direction == 1:
		animated_sprite_2d.flip_h = false
	if direction == -1:
		animated_sprite_2d.flip_h = true


	await get_tree().create_timer(1).timeout
	knockback_toggle = false
	move_and_slide()
	
func _knockback(enemyPosition: Vector2):
	knockback_toggle == true
	var knockbackDirection = (global_position - enemyPosition).normalized()
	knockback.x = knockbackDirection.x * 500
	knockback_timer = 0.3

	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "hitbox":
		_knockback(area.get_parent().position)
		print("collided")
		
