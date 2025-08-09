extends TextureButton

@onready var button_press: AudioStreamPlayer2D = %ButtonPress

func _on_pressed() -> void:
	button_press.play()

func _on_button_press_finished() -> void:
	get_tree().reload_current_scene()
