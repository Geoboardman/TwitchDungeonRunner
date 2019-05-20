extends "res://engine/entity.gd"


var move_timer_length = 15
var move_timer = 0

func _ready():
	SPEED = 40
	move_dir = dir.rand()

func _physics_process(delta):
	movement_loop()
	