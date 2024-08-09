extends Node

const FILE_BEGIN = "res://Scenes/level_"
var current_scene_file : String = ""
var next_level_path : String = ""

@onready var sceneTransition = $AnimationPlayer

func _ready() -> void:
	current_scene_file = str(get_tree().current_scene.scene_file_path.to_int() + 1)
	next_level_path = FILE_BEGIN + current_scene_file + ".tscn"
	# Connect the "animation_finished" signal to a function in this script
	sceneTransition.connect("animation_finished", Callable(self, "_on_animation_finished"))
	# Plays the animation backward to fade in
	#sceneTransition.play_backwards("Fade")

func _on_area_entered(area):
	if area.is_in_group("Player"):
		sceneTransition.play("Fade")

		
func _on_animation_finished(anim_name : String):
	print(anim_name)
	if anim_name == "Fade":
		get_tree().change_scene_to_file(next_level_path)


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
