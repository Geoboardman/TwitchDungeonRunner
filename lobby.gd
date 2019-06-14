extends Control

#### Network callbacks from SceneTree ####

# callback from SceneTree
func _player_connected(_id):
	#someone connected, start the game!
	var main = load("res://Main.tscn").instance()
	main.connect("game_finished", self, "_end_game", [], CONNECT_DEFERRED) # connect deferred so we can safely erase it from the callback
	
	get_tree().get_root().add_child(main)
	hide()

func _player_disconnected(_id):

	if get_tree().is_network_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")

# callback from SceneTree, only for clients (not server)
func _connected_ok():
	# will not use this one
	pass
	
# callback from SceneTree, only for clients (not server)	
func _connected_fail():

	_set_status("Couldn't connect",false)
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("panel/join").set_disabled(false)
	get_node("panel/host").set_disabled(false)

func _server_disconnected():
	_end_game("Server disconnected")
	
##### Game creation functions ######

func _end_game(with_error=""):
	if has_node("/root/Main"):
		#erase main scene
		get_node("/root/Main").free() # erase immediately, otherwise network might show errors (this is why we connected deferred above)
		show()
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("panel/join").set_disabled(false)
	get_node("panel/host").set_disabled(false)
	
	_set_status(with_error, false)

func _set_status(text, isok):
	#simple way to show status		
	if isok:
		get_node("panel/status_ok").set_text(text)
		get_node("panel/status_fail").set_text("")
	else:
		get_node("panel/status_ok").set_text("")
		get_node("panel/status_fail").set_text(text)

func _on_host_pressed():
	gamestate.host_game()
	get_node("panel/join").set_disabled(true)
	get_node("panel/host").set_disabled(true)
	_set_status("Waiting for player..", true)

func _on_join_pressed():
	gamestate.join_game()
	_set_status("Connecting..", true)


### INITIALIZER ####
	
func _ready():
	# Called every time the node is added to the scene.
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	
