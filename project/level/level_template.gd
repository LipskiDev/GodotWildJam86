extends Node3D

func _ready() -> void:
	Globals.player_died.connect(hide_hud)
	
func hide_hud() -> void:
	$Hud.hide()
