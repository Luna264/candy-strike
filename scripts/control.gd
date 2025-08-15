extends Control

@onready var retry: CanvasLayer = %retry

func _ready() -> void:
	visible = true

func _process(delta: float) -> void:
	if retry.visible == true:
		visible = false
		
