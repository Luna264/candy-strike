extends Node2D

@onready var current_level = 1
@onready var max_level = 2
@onready var level_manager = get_tree().get_first_node_in_group("level_manager")
@onready var enemy_dict = { # level : enemy count
	1: 1,
}
@onready var enemy_scene = preload("res://scenes/enemys/chococake.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0

@onready var wave_timer = get_node("%WaveTimer")
@onready var player = get_tree().get_first_node_in_group("player")
var canSpawn = false



func _ready():
	add_to_group("level")

func enemy_death():
	print("enemy died")
	dead_enemies += 1
	level_manager.totalDeaths += 1
	if dead_enemies == enemy_dict.get(current_level, 0) and not level_manager.level_over:
		wave_timer.start()
		dead_enemies = 0

func spawn_enemies():
	if enemy_dict.has(current_level):
		if level_manager.level_now == "Level_1":
			for i in range(enemy_dict[current_level]):
				var new_enemy = enemy_scene.instantiate()
				var spawn_length = get_child_count() - 1
				var spawn_num = rand.randi_range(0, spawn_length)
				var spawn_position = get_child(spawn_num).position

				new_enemy.position = spawn_position
				new_enemy.spawner = self
				add_child(new_enemy)
					
				if player and not new_enemy.damage_output.is_connected(player._on_chococake_damage_output):
					new_enemy.damage_output.connect(player._on_chococake_damage_output)
				
				await get_tree().create_timer(2.0).timeout
	else:
		print("LEVEL OVER! not spawning anymore")

func update_level(level):
	spawn_enemies()


func _on_wave_timer_choco_timeout() -> void:
	if not level_manager.level_over:
		print("finished level:", current_level)

		if current_level >= max_level:
			print("all levels finished")
			return

		current_level += 1
		update_level(current_level)


func _process(delta: float) -> void:
	if level_manager.level_now == "Level_1" and level_manager.totalDeaths < 20:
		await get_tree().create_timer(1.0).timeout
	elif level_manager.totalDeaths >= 20 and canSpawn == false:
		update_level(current_level)
		canSpawn = true
		
		
