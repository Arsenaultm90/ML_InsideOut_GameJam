extends Node

var numOfBlocks = 0
var activeBlock : bool = false
var inAir : bool = false
var my_label : Label 

# Called when the node enters the scene tree for the first time.
func _ready():
	var uiScene = load("res://GUI/UI_Nodes/block_count.tscn")
	var root_node = uiScene.instantiate()
	my_label = root_node.get_node("Label")
	
		# Add the entire UI scene to the current active scene
	if get_tree().root.get_child_count() > 0:
		# Assuming your main scene is the first child of the root
		var current_scene = get_tree().root.get_child(0)
		current_scene.add_child(root_node)
	else:
		print("Error: No current scene found to add the UI element to!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if my_label:
		# Update the label's text each frame based on numOfBlocks
		my_label.text = str(numOfBlocks)
