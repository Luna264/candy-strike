extends Area2D
@onready var player = get_parent()

@onready var basic_attack: AudioStreamPlayer2D = %BasicAttack
@onready var crit_attack: AudioStreamPlayer2D = %CritAttack
@onready var slash: AudioStreamPlayer2D = %Slash
@onready var slash_crit: AudioStreamPlayer2D = %SlashCrit

var dmg = 0
var knock_x = 0
var knock_y = 0

signal enemyShakescreen

func hit(delta: float) -> void:
	if player.is_crit == false:
		dmg = 10	
		knock_x = 200
		knock_y = -200
		
		
	if player.is_crit == true:
		dmg = 20
		knock_x = 350
		knock_y = -350
		
		
	var overlapping = get_overlapping_bodies()
	#print("Overlapping bodies: ", overlapping)
	
	for body in get_overlapping_bodies():
		
		if body.has_method("take_damage"):
			emit_signal("enemyShakescreen")
			body.take_damage(dmg, global_position, knock_x, knock_y) #passing in candy cane global position which enemy takes as attacker_positio
			if player.is_crit == false:
				basic_attack.play()
			if player.is_crit == true:
				crit_attack.play()


#func _on_animation_player_animation_finished(anim_name) -> void:
	#if anim_name.begins_with("b_attack") or anim_name.begins_with("c_attack"):
		#player.is_damaged = false
		#player.is_attacking = false

	#elif anim_name == "hit":
		#player.is_damaged = false
		#player.is_attacking = false

		
