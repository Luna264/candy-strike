extends Node2D


@onready var current_level = 0
@onready var max_level = 2
@onready var level_manager = get_tree().get_first_node_in_group("level_manager")
@onready var enemy_dict={ #level = key, enemy amount = value
	1:1,
	2:2
}
@onready var enemy =preload("res://scenes/enemys/slime.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0

@onready var wave_timer = get_node("%WaveTimer")
#@onready var resets = 0 #if resets is greater than a certain value, next level

func _ready():
	add_to_group("level")
	
func enemy_death():
	print("enemy died")
	dead_enemies += 1
	level_manager.totalDeaths += 1
	if dead_enemies == enemy_dict[current_level]: #searching for the monster dict key equal to current level
		wave_timer.start()
		dead_enemies = 0
	
func spawn_enemies():	
	if max_level >= current_level:
		for i in range(enemy_dict[current_level]): #the enemy number of the current level
			var e = enemy.instantiate()
	
			var spawn_length = get_child_count() - 1
			var spawn_num = rand.randi_range(0, spawn_length)
			var spawn_position = get_child(spawn_num).position
	
			e.position = spawn_position
			add_child(e)
	
			await get_tree().create_timer(2.0).timeout
	else:
		print("LEVEL OVER! not spawning anymore")
	
func update_level(level):
	spawn_enemies()


func _on_wave_timer_timeout() -> void:
	print("finished level: ", current_level)
	current_level += 1
	update_level(current_level)
