extends Node

signal world_changed(world_name)
var entered = false

@export var world_name : String = "world"

func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("world_changed")
