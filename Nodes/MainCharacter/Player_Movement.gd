extends CharacterBody2D

enum States {IDLE, RUNNING, JUMPING, FALLING, EATING}
var state: States = States.IDLE
@export var SPEED : int = 155
@export var GRAVITY : int = 700
@export var JUMP_FORCE : int = 300
@onready var area = $Area2D
@onready var sprite = $Area2D/AnimatedSprite2D
var current_animation: String = ""
var input_locked: bool = false


func _ready():
	area.connect("area_entered", Callable(self, "_on_area_entered"))
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
func _on_animation_finished(anim_name: String) -> void:
	print("Im here")
	if anim_name == current_animation:
		input_locked = false  # Re-enable input when the animation finishes
	
func _on_area_entered(colArea: Area2D) -> void:
	# Check if the colliding object is the StaticBody2D you want to interact with
	if colArea.is_in_group("Food"):  # Ensure your StaticBody2D is in this group
		print("Collided with Food")
		state = States.EATING
		set_state(state)
	

func _physics_process(delta):
	if not input_locked:
		var direction = Input.get_axis("Left", "Right")
		var is_initiating_jump = is_on_floor() and Input.is_action_just_pressed("Jump")
		
		# Determine the new state based on input and current state
		if is_initiating_jump:
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
		elif state == States.JUMPING:
			# Set a jump force if in the JUMPING state
			if is_on_floor():  # Only apply the jump force if on the floor
				velocity.y = -JUMP_FORCE
			velocity.x = direction * SPEED
		else:
			velocity.x = 0

		# Apply gravity
		if not is_on_floor():
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
			
func play_animation(anim_name: String) -> void:
	if sprite and sprite.animation != anim_name:
		current_animation = anim_name
		if current_animation == "Eat":
			input_locked = true  # Disable input while the animation is playing
		sprite.play(anim_name)
