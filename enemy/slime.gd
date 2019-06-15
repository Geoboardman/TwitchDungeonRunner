extends "res://engine/entity.gd"


var move_timer_length = 15
var move_timer = 0
puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

func _ready():
	SPEED = 40
	if is_network_master():
		move_dir = dir.rand()

func _physics_process(delta):
	if is_network_master():
		if move_timer > 0:
			move_timer -= 1
		elif move_timer == 0 or is_on_wall():
			move_dir = dir.rand()
			move_timer = move_timer_length
		rset("puppet_move_dir", move_dir)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		move_dir = puppet_motion
	movement_loop()