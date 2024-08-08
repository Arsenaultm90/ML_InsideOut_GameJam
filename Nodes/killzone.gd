extends Area2D

@onready var timer = $Timer



func _on_body_entered(_body):
	print("You died!")
	timer.start()
	
