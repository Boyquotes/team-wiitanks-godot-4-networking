extends CharacterBody2D

const SPEED = 300.0

# update input and movement every physics tick
func _physics_process(_delta):
	var velocityVec = Vector2()
	
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
