extends CharacterBody2D


@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var buffer_timer: Timer = $BufferTimer
@onready var animation_playerCC: AnimationPlayer = $AnimationPlayer
@onready var candycane: Area2D = $candycane
@onready var anim_player = candycane.get_node("AnimationPlayer")
@onready var attack: Timer = $Attack

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var is_crit = false
var is_attacking = false

func _process(delta: float) -> void:
#ATTACKING
	if Input.is_action_just_pressed("b_attack"):
		is_crit = false
		is_attacking = true
		anim_player.play("attackbase")
		attack.start()
		
	if Input.is_action_just_pressed("c_attack"):
		is_crit = true
		is_attacking = true
		anim_player.play("attackcrit")
		attack.start()
	

		

func _on_attack_timeout() -> void:
	is_attacking = false
	anim_player.play("RESET")

#---------------------------------------------------------

var was_on_floor = false
func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if was_on_floor and not is_on_floor() and velocity.y > 0:
		coyote_timer.start()
	was_on_floor = is_on_floor()
	
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		buffer_timer.start()
		
	# Handle jump.
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
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#direction flipping
	if direction == 1:
		animated_sprite_2d.flip_h = false
	if direction == -1:
		animated_sprite_2d.flip_h = true

	move_and_slide()
