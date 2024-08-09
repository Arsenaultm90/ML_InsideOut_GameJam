extends Area2D

const FILE_BEGIN = "res://Scenes/level_"
var current_scene_file : String = ""
var next_level_number = current_scene_file.to_int() + 1
var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"

@onready var sceneTransition = $SceneTransitionRect/AnimationPlayer

func _ready() -> void:
	current_scene_file = str(get_tree().current_scene.scene_file_path.to_int() + 1)
	# Connect the "animation_finished" signal to a function in this script
	sceneTransition.connect("animation_finished", Callable(self, "_on_animation_finished"))
	# Plays the animation backward to fade in
	sceneTransition.play_backwards("Fade")

func _on_area_entered(area):
	print("In area")
	if area.is_in_group("Player"):
		sceneTransition.play("Fade")

		
func _on_animation_finished():
	get_tree().change_scene_to_file(next_level_path)
