extends CharacterBody2D


@export var period:int = 100
@export var amplitude:int = 100
var x_midpoint:float

func _ready():
	x_midpoint = get_viewport().size.x / 2
	position = Vector2(x_midpoint, get_viewport().size.y / 2)

func _physics_process(delta):
	
	var time:float = Time.get_ticks_msec() / period;
	var newPos:float = sin(time) * amplitude
	#print(newPos)
	
	position.x = x_midpoint + newPos
	
