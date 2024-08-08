extends Node2D

var Sprite2DScene : PackedScene = preload("res://Nodes/BlockNodes/poop_block.tscn")
var sprite : StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if GlobalManager.activeBlock == true:
		sprite.position = get_global_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Poop_Block") and GlobalManager.activeBlock == false and GlobalManager.numOfBlocks > 0 and GlobalManager.inAir == false:
		GlobalManager.numOfBlocks -= 1
		sprite = Sprite2DScene.instantiate() as StaticBody2D  # Ensure typecasting
		GlobalManager.activeBlock = true
		sprite.collision_layer = 2
		if sprite:
			add_child(sprite)
			sprite.position = get_global_mouse_position()
			sprite.visible = true  # Ensure the sprite is set to visible
			sprite.z_index = 5  # Ensure the sprite is drawn above other elements
		else:
			print("Failed to instantiate the sprite scene!")
	
	if Input.is_action_just_pressed("Place_Block") and sprite != null:
		sprite.z_index = 1 
		GlobalManager.activeBlock = false
		sprite.collision_layer = 1
