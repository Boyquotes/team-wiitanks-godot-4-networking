extends RigidBody2D

@export var period: int = 100
@export var amplitude: int = 100

@onready var age_label: Label = get_node("age-text")
@onready var viewport_x: int = get_viewport().size.x
@onready var viewport_y: int = get_viewport().size.y


func _ready():
	# initialize self in a random position on the board
	var random := RandomNumberGenerator.new()
	random.randomize()
	position = Vector2(viewport_x * random.randf(), viewport_y * random.randf())


func _physics_process(delta):
	# move in a sinusoidal fashion along the x axis
	var msecs:int = Time.get_ticks_msec();
	#var new_pos:float = sin(msecs / period) * amplitude
	#position.x = x_midpoint + new_pos
	
	# wrap x and y axis around like pac-man
	if position.x > viewport_x:
		linear_velocity.x = -200
	elif position.x < 0:
		linear_velocity.x = 200
	
	if position.y > viewport_y:
		linear_velocity.y = -1000
	
	# show ball's age in seconds
	age_label.text = str(msecs / 1000);

