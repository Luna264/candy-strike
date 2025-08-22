extends Node2D

@onready var current_level = 1
@onready var level_manager = get_tree().get_first_node_in_group("level_manager")
@onready var enemy_dict = { # level : enemy count
	1: 2,
	2: 2,
	3: 4,
	4: 4,
	5: 1,
	6: 3,
	7: 1
}

@onready var enemy_dictLEVELTWO = {
	1: 2,
	2: 2,
	3: 3,
	4: 2,
	5: 2,
	6: 2,
	7: 2
}

@onready var enemy_scene = preload("res://scenes/enemys/slime.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0

@onready var wave_timer = get_node("%WaveTimer")
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	update_level(current_level)
	add_to_group("level")

func enemy_death():
	print("enemy died")
	dead_enemies += 1
	level_manager.totalDeaths += 1
	if dead_enemies == enemy_dict.get(current_level, 0) and not level_manager.level_over and get_tree().current_scene.name == "Level1":
		wave_timer.start()
		dead_enemies = 0
	if dead_enemies == enemy_dictLEVELTWO.get(current_level, 0) and not level_manager.level_over and get_tree().current_scene.name == "Level2":
		wave_timer.start()
		dead_enemies = 0

func spawn_enemies():
	var level_now = get_tree().current_scene.name
	#print(level_now)
	if level_now == "Level1":
		if enemy_dict.has(current_level):
			for i in range(enemy_dict[current_level]):
				var new_enemy = enemy_scene.instantiate()
				var spawn_length = get_child_count() - 1
				var spawn_num = rand.randi_range(0, spawn_length)
				var spawn_position = get_child(spawn_num).position

				new_enemy.position = spawn_position
				new_enemy.spawner = self
				add_child(new_enemy)
				await get_tree().create_timer(2.0).timeout
		
	#---------------------------------------------------------------------------------------------------------------
		
		
	if level_now == "Level2":
		if enemy_dictLEVELTWO.has(current_level):
			for i in range(enemy_dictLEVELTWO[current_level]):
				var new_enemy = enemy_scene.instantiate()
				var spawn_length = get_child_count() - 1
				var spawn_num = rand.randi_range(0, spawn_length)
				var spawn_position = get_child(spawn_num).position

				new_enemy.position = spawn_position
				new_enemy.spawner = self
				add_child(new_enemy)
										
				if player and not new_enemy.damage_output.is_connected(player._on_slime_damage_output):
					new_enemy.damage_output.connect(player._on_slime_damage_output)
								
				await get_tree().create_timer(2.0).timeout		


func update_level(level):
	spawn_enemies()

func _on_wave_timer_timeout() -> void:
	if not level_manager.level_over:
		print("finished level:", current_level)

		current_level += 1
		update_level(current_level)
		
