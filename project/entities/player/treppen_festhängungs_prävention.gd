extends Node3D


const MAX_STEP_HEIGHT = 0.5


@export var player: Player


var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF


@onready var stairs_below_ray_cast: RayCast3D = $StairsBelowRayCast
@onready var stairs_ahead_ray_cast: RayCast3D = $StairsAheadRayCast


func _physics_process(delta: float) -> void:
	if not _snap_up_stairs_check(delta):
		_snap_down_to_stairs_check()


func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > player.floor_max_angle


func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	stairs_below_ray_cast.force_raycast_update()
	var floor_below : bool = stairs_below_ray_cast.is_colliding() and not is_surface_too_steep(stairs_below_ray_cast.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if not player.is_on_floor() and player.velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = KinematicCollision3D.new()
		if player.test_move(player.global_transform, Vector3(0,-MAX_STEP_HEIGHT,0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			player.position.y += translate_y
			player.apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap


func _snap_up_stairs_check(delta) -> bool:
	if not player.is_on_floor() and not _snapped_to_stairs_last_frame: 
		return false
	
	if player.velocity.y > 0.0 or (player.velocity * Vector3(1.0, 0.0, 1.0)).length() == 0.0: 
		return false
	
	var expected_move_motion = player.velocity * Vector3(1.0, 0.0, 1.0) * delta
	var step_pos_with_clearance = player.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	
	
	var down_check_result = KinematicCollision3D.new()
	if (player.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - player.global_position).y
		
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - player.global_position).y > MAX_STEP_HEIGHT: 
				return false
			
		stairs_ahead_ray_cast.global_position = down_check_result.get_position() + Vector3(0.0 ,MAX_STEP_HEIGHT, 0.0) + expected_move_motion.normalized() * 0.1
		stairs_ahead_ray_cast.force_raycast_update()
		#print(stairs_ahead_ray_cast.get_collider())
		if stairs_ahead_ray_cast.is_colliding(): # and not is_surface_too_steep(stairs_ahead_ray_cast.get_collision_normal()):
			#print(down_check_result)
			#printt("pos before: ", player.global_position)
			player.global_position = step_pos_with_clearance.origin + down_check_result.get_travel() * 0.99
			#printt("pos after: ", player.global_position)
			player.apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
