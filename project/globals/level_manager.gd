extends Node


const levels: Array[PackedScene] = [
	preload("res://level/level_1.tscn"),
	preload("res://level/level_2.tscn"),
	preload("res://level/level_3.tscn"),
	preload("res://level/level_4.tscn"),
	preload("res://level/level_5.tscn")
]


@onready var level_container: Node = $LevelContainer
@onready var animation_player: AnimationPlayer = $LevelTransition/AnimationPlayer
@onready var level_transition: ColorRect = $LevelTransition


func change_level(level_index: int, transition_color: Color) -> void:
	level_transition.color = transition_color.darkened(0.5)
	animation_player.play("fade_in")
	
	await get_tree().create_timer(1.0).timeout
	
	if level_container.get_child_count() > 0:
		level_container.get_child(0).queue_free()
	
	var level = levels[level_index].instantiate()
	level_container.add_child(level)
	animation_player.play("fade_out")


func _on_loading_screen_finished() -> void:
	var level = levels[0].instantiate()
	level_container.add_child(level)
	animation_player.play("fade_out")
