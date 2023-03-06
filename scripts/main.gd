extends Node2D

# an object that handles various networking tasks
var multiplayerPeer = ENetMultiplayerPeer.new()

# info on what computer to connect to. for development, just loopback to self.
# port number isn't too important unless reserved (past first 1024 is safe)
const PORT = 9999
const ADDRESS = "localhost"

var connected_peer_ids = []

func _on_buttonhost_pressed():
	# hide buttons, show this machine is a server
	get_node("container-network-info/network-role").text = "Server"
	get_node("container-menu").visible = false
	
	# instruct multiplayerPeer to make a server, listening on PORT
	multiplayerPeer.create_server(PORT)
	# register multiplayerPeer object to handle multiplayer operations in multiplayer api
	multiplayer.multiplayer_peer = multiplayerPeer
	# each peer on network has unique id, display this machine's unique id
	get_node("container-network-info/label-peer-id").text = str(multiplayer.get_unique_id())
	
	# instantiate character for host to control. server's network id is always 1.
	add_player_character(1)
	
	# connect a lambda function to multiplayerPeer, called when a peer connects to this host.
	multiplayerPeer.peer_connected.connect(
		# anonymous function always given the id of the new peer machine
		func (new_peer_id):
			await get_tree().create_timer(1).timeout
			# 
			rpc("add_newly_connected_player_character")
			# call func adding characters of previously connected machines of machine at new_peer_id
			# and give connectedPeerIds as an argument
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			
			# add own character, not duplicating after the rpc_id call
			add_player_character(new_peer_id)
	)

func _on_buttonjoin_pressed():
	# hide buttons, show this machine is a client
	get_node("container-network-info/network-role").text = "Client"
	get_node("container-menu").visible = false
	
	# instruct multiplayerPeer to make a client, connect to ADDRESS and listen on PORT
	multiplayerPeer.create_client(ADDRESS, PORT)
	
	multiplayer.multiplayer_peer = multiplayerPeer
	get_node("container-network-info/label-peer-id").text = str(multiplayer.get_unique_id())

# when called, instantiate the player scene, add instance to scene
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://scenes/player.tscn").instantiate()
	add_child(player_character)

# remotely-callable function 
@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

func _on_messageinput_text_submitted(new_text):
	pass # Replace with function body.
