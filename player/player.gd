extends "res://engine/entity.gd"

var state = "moving"

#synchronize position and speed to the other peers
puppet func set_pos_and_motion(dir):
	move_dir = dir

func controls_loop():
	var LEFT = Input.is_action_pressed("move_left")
	var RIGHT = Input.is_action_pressed("move_right")
	var UP = Input.is_action_pressed("move_up")
	var DOWN = Input.is_action_pressed("move_down")
	
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)

sync func attacking():
	state = "attacking"
	anim_switch("attack")


func _physics_process(delta):
	if is_network_master():
		controls_loop()		
		if Input.is_action_pressed("attack"):
			if state != "attacking":
				rpc("attacking")
		#using unreliable to make sure position is updated as fast as possible, even if one of the calls is dropped
		rpc_unreliable("set_pos_and_motion", move_dir)
	sprite_dir_loop()
	if state == "moving":
		movement_loop()
		if move_dir == dir.center:
			anim_switch("idle")
		else:
			anim_switch("walk")			

func _on_anim_animation_finished(anim_name):
	if "attack" in anim_name:
		state = "moving"
		
# sync func take_damage(by_who):
	