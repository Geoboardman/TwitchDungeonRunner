extends "res://engine/entity.gd"

var state = "moving"

func controls_loop():
	var LEFT = Input.is_action_pressed("move_left")
	var RIGHT = Input.is_action_pressed("move_right")
	var UP = Input.is_action_pressed("move_up")
	var DOWN = Input.is_action_pressed("move_down")
	
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)

func attacking():
	state = "attacking"
	anim_switch("attack")

func _physics_process(delta):
	controls_loop()
	sprite_dir_loop()
	if state == "moving":
		movement_loop()
	if Input.is_action_pressed("attack"):
		if state != "attacking":
			attacking()

func _on_anim_animation_finished(anim_name):
	if "attack" in anim_name:
		state = "moving"
