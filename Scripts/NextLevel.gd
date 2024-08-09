extends Area2D

const FILE_BEGIN = "res://Scenes/level_"
var current_scene_file : String = ""
var next_level_path : String = ""
var animator = null

func _ready() -> void:
	animator = get_parent().get_node("AnimationPlayer")
	print(get_parent())
	current_scene_file = str(get_tree().current_scene.scene_file_path.to_int())
	next_level_path = FILE_BEGIN + str(current_scene_file.to_int() + 1) + ".tscn"

	# Plays the animation backward to fade in
	animator.play("SceneTransition/fade_in")

func _on_area_entered(area):
	if area.is_in_group("Player"):
		print("Entered area")
		$SceneTransitionRect.z_index = 20
		animator.play("SceneTransition/fade")

func _on_animation_player_animation_finished(anim_name):
	print("Animation done")
	if anim_name == "SceneTransition/fade":
		get_tree().change_scene_to_file(next_level_path)
