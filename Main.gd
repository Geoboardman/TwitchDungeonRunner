extends Node2D

signal game_finished()

func _on_exit_game_pressed():
	emit_signal("game_finished")	

func _ready():
	# by default, all nodes in server inherit from master
	# while all nodes in clients inherit from puppet
	if get_tree().is_network_server():		
		#if in the server, get control of player 2 to the other peeer, this function is tree recursive by default
		get_node("player").set_network_master(get_tree().get_network_connected_peers()[0])
	else:
		#if in the client, give control of player 2 to itself, this function is tree recursive by default
		get_node("player").set_network_master(get_tree().get_network_unique_id())

	print("unique id: ", get_tree().get_network_unique_id())
