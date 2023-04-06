extends CharacterBody2D

# movement speed of the player
const SPEED = 300.0


func _ready():
	# get network authority (self) and display on character.
	name = str(get_multiplayer_authority())
	get_node("label-name").text = str(name)
	
	# initialize self in a random position
	var random := RandomNumberGenerator.new()
	random.randomize()
	position = Vector2(get_viewport().size.x * random.randf(), get_viewport().size.y * random.randf())


# update input and movement every physics tick
func _physics_process(_delta):
	
	# allow movement if this node's unique id matches that of the multiplayer authority.
	# since each machine is its own network authority of its own player, only they 
	# can move their player.
	if is_multiplayer_authority():
		var velocityVec := Vector2()

		# add horizontal motion to vector.
		if Input.is_action_pressed("ui_right"):
			velocityVec.x = SPEED
		elif Input.is_action_pressed("ui_left"):
			velocityVec.x = -SPEED
		else:
			velocityVec.x = 0

		# add vertical motion to vector. note this axis is inverted.
		if Input.is_action_pressed("ui_down"):
			velocityVec.y = SPEED
		elif Input.is_action_pressed("ui_up"):
			velocityVec.y = -SPEED
		else:
			velocityVec.y = 0

		# inbuilt godot movement smoothing
		set_velocity(velocityVec)
		move_and_slide()
		
		# communicate this player's new position to all other machines
		rpc("remote_set_position", global_position)


# accept whatever position the network authority says this player should be at.
@rpc("unreliable")
func remote_set_position(authority_position) -> void:
	global_position = authority_position

