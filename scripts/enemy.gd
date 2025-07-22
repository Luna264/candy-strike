extends CharacterBody2D

var health = 150
var speed = 80.0
var friction = 500.0 
@onready var pause_timer: Timer = $pause_timer

signal knockback

func _process(delta: float) -> void:
	if health < 0:
		print("dead at under 0")
		queue_free()
		
	if health == 0:
		print("dead at 0")
		queue_free()
		
func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	emit_signal("knockback", global_position)
	health = health - dmg
	var direction = (global_position - attacker_position).normalized() #normalize = direction, just want to know where its pointing, not the length
	velocity.x = direction.x * knockback_x
	velocity.y = knockback_y
	#await get_tree().create_timer(0.1).timeout
	#pause_timer.start()
	#get_tree().paused = true
	
	
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() and velocity.y > 0:
		velocity.y = 0 
		
	velocity.x = move_toward(velocity.x, 0, friction * delta) #from, to, by amount of friction
	move_and_slide()
