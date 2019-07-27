extends Area2D

var in_area = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func attack():
	if not is_network_master():
		return
	var from_player = get_tree().get_network_unique_id()
	for target in in_area:
		if target.has_method("take_damage"):
			target.rpc("take_damage", from_player) 

func _on_sword_body_entered(body):
	if not body in in_area:
		in_area.push(body)

func _on_sword_body_exited(body):
	in_area.erase(body)		
