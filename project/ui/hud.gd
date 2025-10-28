extends CanvasLayer


func _ready() -> void:
	Globals.play_credits.connect(_on_play_credits)
	
	
func hide_hud() -> void:
	hide()


func _on_play_credits():
	hide_hud()
