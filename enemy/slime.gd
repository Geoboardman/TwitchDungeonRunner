extends "res://engine/entity.gd"


var move_timer_length = 15
var move_timer = 0

func _ready():
	SPEED = 40
	move_dir = dir.rand()

func _physics_process(delta):
	movement_loop()
	if move_timer > 0:
		move_timer -= 1
	elif move_timer == 0 or is_on_wall():
		move_dir = dir.rand()
		move_timer = move_timer_length