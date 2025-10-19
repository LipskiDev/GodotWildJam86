extends Node


@warning_ignore("unused_signal")
signal damage_taken
@warning_ignore("unused_signal")
signal player_died

@warning_ignore("unused_signal")
signal shoot_spike(pos: Vector3, dir: Vector3)

@warning_ignore("unused_signal")
signal mask_collected(n: int)
@warning_ignore("unused_signal")
signal mask_switched

var current_mask: int = 0
