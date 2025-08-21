extends Node2D

@onready var current_level = 1
@onready var level_manager = get_tree().get_first_node_in_group("level_manager")
@onready var enemy_dictLEVELTWO = { # level : enemy count
	1: 1,
	2: 1,
}
@onready var enemy_scene = preload("res://scenes/enemys/whiP.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var wave_timer = get_node("%WaveTimerWhip")
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	await get_tree().create_timer(7.0).timeout		
	update_level(current_level)
	add_to_group("level")

func enemy_death():
	print("enemy died")
	dead_enemies += 1
	level_manager.totalDeaths += 1
	if dead_enemies == enemy_dictLEVELTWO.get(current_level, 0) and not level_manager.level_over and get_tree().current_scene.name == "Level2":
		wave_timer.start()
		dead_enemies = 0

func spawn_enemies():
	print("EENMYSPAW")
	var level_now = get_tree().current_scene.name
	if level_now == "Level2":
		if enemy_dictLEVELTWO.has(current_level):
			for i in range(enemy_dictLEVELTWO[current_level]):
				var new_enemy = enemy_scene.instantiate()
				var spawn_length = get_child_count() - 1
				var spawn_num = rand.randi_range(0, spawn_length)
				var spawn_position = get_child(spawn_num).position
				var screen = get_viewport_rect().size.x / 2
				if new_enemy.position.x > screen:
					new_enemy.scale.x = 1
				else:
					new_enemy.scale.x = -1
				new_enemy.position = spawn_position
				new_enemy.spawner = self
				add_child(new_enemy)
				await get_tree().create_timer(2.0).timeout		
#---------------------------------------------------------------------------------------------------------------


func update_level(level):
	spawn_enemies()


func _on_wave_timer_whip_timeout() -> void:
	print(current_level)
	if not level_manager.level_over:
		print("whip finished level:", current_level)

		current_level += 1
		update_level(current_level)
		
