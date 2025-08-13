extends Camera2D

@export var decay : float = 0.8 
@export var max_offset : Vector2 = Vector2(100, 75) 
@export var max_rot : float = 0.1 
@export var follow_node : Node2D 

@onready var player = get_tree().get_first_node_in_group("player")
@onready var candycane = get_tree().get_first_node_in_group("candycane")


var trauma : float = 0.0
var trauma_power : int = 2 


func _ready() -> void:
	if not player.shakescreenplayer.is_connected(_on_player_shakescreenplayer):
		player.shakescreenplayer.connect(_on_player_shakescreenplayer)
	if not candycane.enemyShakescreen.is_connected(_on_candycane_enemy_shakescreen):
		candycane.enemyShakescreen.connect(_on_candycane_enemy_shakescreen)

func _process(delta : float) -> void:
	if follow_node: 
		global_position = follow_node.global_position
	if trauma: #if camera is shaking
		trauma = max(trauma - decay * delta, 0)  # decay but also
		shake()  #add shake


func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 0.3)  #how much shake 

func shake() -> void:
	var amount = pow(trauma, trauma_power) #trauma ^ trauma power
	rotation = max_rot * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1) #random number so isnt same shake
	
	

	
func _on_player_shakescreenplayer() -> void: #player
	add_trauma(0.2)
	shake()

func _on_candycane_enemy_shakescreen() -> void:
	add_trauma(0.2)
	shake()
