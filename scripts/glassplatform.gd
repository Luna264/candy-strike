extends AnimatableBody2D

var breaking_timer: float = 0.0
var is_breaking = false
var is_shattering = false
var body_under = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detection: Area2D = $detection

signal shatter

func _physics_process(delta: float) -> void:
	print(breaking_timer)
	if is_breaking == true and body_under == false:
		breaking_timer += delta
		
	if is_breaking == false and is_shattering == false:
		breaking_timer = 0
		animation_player.play("idle")
	
	if is_breaking == true and not is_shattering and body_under == false:
		animation_player.play("breaking")
		
	if breaking_timer > 0.7:
		is_shattering = true
		emit_signal("shatter")
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("enemy") and body_under == false:
			is_breaking = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("enemy"):
			is_breaking = false

func _on_shatter() -> void:
	animation_player.play("shattering")


func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("enemy"):
		print("body under TRUTHFUL")
		body_under = true


func _on_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("enemy"):
		print('body under FALSE')
		body_under = false
