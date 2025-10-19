extends Node


@warning_ignore("unused_signal")
signal damage_taken
@warning_ignore("unused_signal")
signal player_died

@warning_ignore("unused_signal")
signal shoot_spike(pos: Vector3, dir: Vector3)

@warning_ignore("unused_signal")
signal teleport_player_to(pos: Vector3)

@warning_ignore("unused_signal")
signal mask_collected(n: int)
@warning_ignore("unused_signal")
signal mask_switched


var is_bonfire_lit: Array[bool] = [false, false, false, false, false, false]
var last_bonfire_scene: String = ""
var player_just_died: bool = false
var next_door_id: int = -1

var current_mask: int = -1
