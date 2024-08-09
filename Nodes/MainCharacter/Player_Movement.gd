extends CharacterBody2D

enum States {IDLE, RUNNING, JUMPING, FALLING, EATING, POOP}
var state: States = States.IDLE
@export var SPEED : int = 155
@export var GRAVITY : int = 700
@export var JUMP_FORCE : int = 225
@onready var area = $Area2D
@onready var sprite = $Area2D/AnimatedSprite2D
var current_animation: String = ""
var input_locked: bool = false
var collision_node : Area2D = null;
var Sprite2DScene : PackedScene = preload("res://Nodes/BlockNodes/poop_block.tscn")
var block_sprite : StaticBody2D
var soundCurrent = soundRunning
var soundRunning = preload("res://Sounds/Running.mp3")
var soundFart = preload("res://Sounds/Fart.mp3")
var soundChomp = preload("res://Sounds/Chomp.mp3")
var musicMain = preload("res://Sounds/PixelDream.mp3")

# Setup signals for collision and sprite animations
func _ready():
	area.connect("area_entered", Callable(self, "_on_area_entered"))
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	$Audio_Music.stream = musicMain
	$Audio_Music.play()
	
# Proceeds with resuming the game once the animation finishes
func _on_animation_finished() -> void:
	if current_animation == "Poop":
		GlobalManager.numOfBlocks -= 1
		block_sprite = Sprite2DScene.instantiate() as StaticBody2D  # Ensure typecasting
		GlobalManager.activeBlock = true
		block_sprite.collision_layer = 2
		if block_sprite:
			get_parent().add_child(block_sprite)
			block_sprite.position = get_global_mouse_position()
			block_sprite.visible = true  # Ensure the sprite is set to visible
			block_sprite.z_index = 5  # Ensure the sprite is drawn above other elements
		else:
			print("Failed to instantiate the sprite scene!")
		input_locked = false  # Re-enable input when the animation finishes
	if current_animation == "Eat":
		collision_node.queue_free()
		input_locked = false  # Re-enable input when the animation finishes
	
func _on_area_entered(colArea: Area2D) -> void:
	# Check collision layers and masking
	if colArea.is_in_group("Food"):  # Ensure your StaticBody2D is in this group
		state = States.EATING
		set_state(state)
		$Audio_SFX.stream = soundChomp
		$Audio_SFX.play()
		collision_node = colArea
		GlobalManager.numOfBlocks += 1
	elif colArea.is_in_group("Killzone"):
		if $Timer.is_stopped():
			$Timer.start()
		
func _on_timer_timeout():
	GlobalManager.activeBlock = false
	GlobalManager.numOfBlocks = 0
	get_tree().reload_current_scene()
	
func _physics_process(delta):
	if GlobalManager.activeBlock == true:
		block_sprite.position = get_global_mouse_position()
		
	if !$Audio_Music.is_playing():
		$Audio_Music.play()
	
	if !$Audio_SFX.is_playing() and soundCurrent == soundRunning:
		$Audio_SFX.stream = soundCurrent
		$Audio_SFX.play()
		
	if Input.is_action_just_pressed("Reset"):
		GlobalManager.activeBlock = false
		GlobalManager.numOfBlocks = 0
		get_tree().reload_current_scene()
		
	if not input_locked:
		var direction = Input.get_axis("Left", "Right")
		var is_initiating_jump = is_on_floor() and Input.is_action_just_pressed("Jump")
		var is_pooping_blocks = Input.is_action_just_pressed("Poop_Block") and GlobalManager.activeBlock == false and GlobalManager.numOfBlocks > 0 and velocity.y == 0
		
		if is_on_floor():
			GlobalManager.inAir = false
		
		if Input.is_action_just_pressed("Place_Block") and block_sprite != null:
			block_sprite.z_index = 1 
			GlobalManager.activeBlock = false
			block_sprite.collision_layer = 1
		
		# Determine the new state based on input and current state
		if is_pooping_blocks:
			state = States.POOP
			$Audio_SFX.stream = soundFart
			$Audio_SFX.play()
		elif is_initiating_jump:
			GlobalManager.inAir = true
			state = States.JUMPING
		elif not is_on_floor():
			if velocity.y > 0:
				state = States.FALLING
			else:
				state = States.JUMPING
		elif direction != 0:
			state = States.RUNNING
		else:
			state = States.IDLE

		# Update velocity based on the state
		if state == States.RUNNING:
			if direction == -1:
				sprite.flip_h = true
			elif direction == 1:
				sprite.flip_h = false
			velocity.x = direction * SPEED
			if !$Audio_SFX.is_playing():
				$Audio_SFX.stream = soundRunning
		elif state == States.JUMPING:
			# Set a jump force if in the JUMPING state
			if is_on_floor():  # Only apply the jump force if on the floor
				velocity.y = -JUMP_FORCE
			velocity.x = direction * SPEED
		else:
			velocity.x = 0

		# Apply gravity
		if not is_on_floor():
			if direction == -1:
				sprite.flip_h = true
			elif direction == 1:
				sprite.flip_h = false
			velocity.x = direction * SPEED
			velocity.y += GRAVITY * delta

		# Call `move_and_slide` to handle movement
		move_and_slide()
		
		# Update the animation based on the state
		set_state(state)

func set_state(new_state: int) -> void:
	# Handle state transitions
	state = new_state
	match state:
		States.IDLE:
			play_animation("Idle")
		States.RUNNING:
			play_animation("Run")
		States.JUMPING:
			play_animation("Jump")
		States.FALLING:
			play_animation("Fall")
		States.EATING:
			play_animation("Eat")
		States.POOP:
			play_animation("Poop")
			
func play_animation(anim_name: String) -> void:
	if sprite and sprite.animation != anim_name:
		current_animation = anim_name
		if current_animation == "Eat" or current_animation == "Poop":
			input_locked = true  # Disable input while the animation is playing
		sprite.play(anim_name)
		


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
