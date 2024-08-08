extends Node2D

var Sprite2DScene : PackedScene = preload("res://Art/Food/taco.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Poop_Block"):
		var m_pos = get_viewport().get_mouse_position()
		var sprite = Sprite2DScene.instantiate()
		add_child(sprite)
		sprite.position = m_pos 
