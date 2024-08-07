extends CharacterBody2D

@export var SPEED : int = 155
@export var GRAVITY : int = 255
@export var JUMP_FORCE : int = 900
var player

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	
	#If you press 'Left' X = -1, press 'Right' X = 1
	var direction = Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		
	move_and_slide()
	
	#Play Animation  ( I tried :'( lol ) 
	#if direction == 0:
		#animated_sprite_2d.play("Idle")
		#else:
			#animated_sprite_2d.play("Run")
	
	#Rotate
	
	# Get the Sprite2D node from the player
	var sprite = $AnimatedSprite2D

	if direction == 1:
		sprite.flip_h = false
	if direction == -1:
		sprite.flip_h = true
	
	#Gravity
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
