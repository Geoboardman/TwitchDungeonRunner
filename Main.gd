extends Node2D

signal game_finished()

onready var twicil = get_node("TwiCIL")
var slime = load("res://enemy/slime.tscn")

const NICK = "BOT_NICK"
const CLIENT_ID = "ifl6tp4wvlh2y0h8hdtvxpg0j0mcmc"
const CHANNEL = "geoboardman"	# Your channel name LOWER CASE
const OAUTH = "oauth:3xwbeya5zmmopshtr1u94cx0gqzigr"

func _on_exit_game_pressed():
	emit_signal("game_finished")	

# Private methods
func __connect_signals():
	twicil.connect("user_appeared", self, "_on_user_appeared")
	twicil.connect("user_disappeared", self, "_on_user_disappeared")

func _command_reply(params):
	var sender = params[0]
	twicil.send_message("Hello, " + str(sender))
	
func _command_stuff(params):
	var sender = params[0]
	twicil.send_message("Wow this stuff really works, " + str(sender))	

sync func _command_spawn_slime(params):
	var enemy = slime.instance()
	enemy.position = Vector2(100,100)
	add_child(enemy)

func send_greeting_help():
	twicil.send_message(
		"Hi, Chat! You can use the following commands now: " +
		"move [x] [y] - to move; rotate [degrees] - to rotate; " +
		"scale [no_params] or [x] [y] - to scale (to 1 1 without params)")

func init_interactive_commands():
	twicil.commands.add("hi", self, "_command_reply", 0, true)
	twicil.commands.add("stuff", self, "_command_stuff", 0, true)
	twicil.commands.add("slime", self, "_command_spawn_slime", 0, true)

# Public methods
func connect_twitch():
	twicil.connect_to_twitch_chat()
	twicil.connect_to_channel(CHANNEL, CLIENT_ID, OAUTH, NICK)

func _ready():
	# by default, all nodes in server inherit from master
	# while all nodes in clients inherit from puppet
	if get_tree().is_network_server():		
		#if in the server, get control of player 2 to the other peeer, this function is tree recursive by default
		get_node("player").set_network_master(get_tree().get_network_connected_peers()[0])
		# __connect_signals()
		twicil.set_logging(true)
		connect_twitch()
		send_greeting_help()
	else:
		#if in the client, give control of player 2 to itself, this function is tree recursive by default
		get_node("player").set_network_master(get_tree().get_network_unique_id())
	init_interactive_commands()
	print("unique id: ", get_tree().get_network_unique_id())
