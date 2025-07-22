extends CharacterBody2D

var health = 150
@export var speed = -80.0
var friction = 500.0 
var damageoutput = 150

signal damage_output

func _process(delta: float) -> void:
	if health <= 0:
		print("enemy dead")
		queue_free()
		
func take_damage(dmg, attacker_position, knockback_x, knockback_y):
	health = health - dmg
	var direction = (global_position - attacker_position).normalized() #normalize = direction, just want to know where its pointing, not the length
	velocity.x = direction.x * knockback_x #multiply direction,where its pointing, by knockback power
	velocity.y = knockback_y #and for y axis too
	
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() and velocity.y > 0:
		velocity.y = 0 
	
	if is_on_floor():
		velocity.x = speed
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta) #from, to, by amount of friction
	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void: #pass in damage
	emit_signal("damage_output", 50)
	
