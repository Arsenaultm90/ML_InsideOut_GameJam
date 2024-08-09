extends Node2D

var numOfBlocks = 0
var activeBlock : bool = false
var inAir : bool = false
var sceneTransition : bool = false
var my_label : Label 
const FILE_BEGIN = "res://Scenes/level_"
var current_scene_file : String = ""
var next_level_path : String = ""
var scene_root_node : Node = null
var anim_transition_node : Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_root_node = get_tree().current_scene
	anim_transition_node = scene_root_node.get_node("SceneTransitionRect")
	print(anim_transition_node)
	
	current_scene_file = str(get_tree().current_scene.scene_file_path.to_int() + 1)
	next_level_path = FILE_BEGIN + current_scene_file + ".tscn"
	
	var uiScene = load("res://GUI/UI_Nodes/block_count.tscn")
	var root_node = uiScene.instantiate()
	my_label = root_node.get_node("Label")
	
		# Add the entire UI scene to the current active scene
	if get_tree().root.get_child_count() > 0:
		var current_scene = get_tree().root.get_child(0)
		current_scene.add_child(root_node)
	else:
		print("Error: No current scene found to add the UI element to!")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if my_label:
		# Update the label's text each frame based on numOfBlocks
		my_label.text = str(numOfBlocks)
	
	if sceneTransition:
		print("transition scene")
		#sceneTransition.play("Fade")
