extends KinematicBody2D

var SPEED = 80

var move_dir = Vector2(0,0)
var sprite_dir = "down"
var sprite

func _ready():
	sprite = get_node("Sprite");

func movement_loop():
	move_and_slide(move_dir * SPEED)
	
func sprite_dir_loop():
	match move_dir:
		dir.left:
			sprite_dir = "right"
			sprite.set_flip_h(true)
		dir.right:
			sprite_dir = "right"
			sprite.set_flip_h(false)
		dir.up:
			sprite_dir = "up"
		dir.down:
			sprite_dir = "down"

func anim_switch(animation):
	var new_anim
	if animation == "idle":
		new_anim = animation
	else:
		new_anim = str(animation,"_",sprite_dir)
	if $anim.current_animation != new_anim:
		$anim.play(new_anim)