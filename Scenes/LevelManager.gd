extends Node2D

var Sprite2DScene : PackedScene = preload("res://Art/Food/taco.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Poop_Block"):
		var sprite = Sprite2DScene.instantiate() as Area2D  # Ensure typecasting
		if sprite:
			add_child(sprite)
			sprite.position = get_global_mouse_position()
			sprite.visible = true  # Ensure the sprite is set to visible
			sprite.z_index = 1  # Ensure the sprite is drawn above other elements
		else:
			print("Failed to instantiate the sprite scene!")
