extends AnimatableBody2D

var breaking_timer: float = 0.0
var is_breaking = false
var is_shattering = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal shatter

func _ready() -> void:
	global_position = Vector2(50, 106)


func _physics_process(delta: float) -> void:
	if is_breaking == true:
		breaking_timer += delta
		
	if is_breaking == false and is_shattering == false:
		breaking_timer -= delta
		animation_player.play("idle")
	
	if is_breaking == true and not is_shattering:
		animation_player.play("breaking")
		
	if breaking_timer > 0.2:
		is_shattering = true
		emit_signal("shatter")
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("enemy"):
		is_breaking = true
		print("HERE")

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("enemy"):
		is_breaking = false
		print("GONE")

func _on_shatter() -> void:
	animation_player.play("shattering")
