class_name Game
extends Node2D

# info on what computer to connect to. for development, just loopback to self.
# port number isn't too important unless reserved (past first 1024 is safe)
const PORT = 9999
const TEST_ADDRESS = "127.0.0.1"
const TESTING_LOCAL = false

# an object that handles various networking tasks
var multiplayerPeer := ENetMultiplayerPeer.new()
var connected_peer_ids: Array = []


func _ready():
	# get a random seed for RNG
	randomize()
	# show user their machine's private IP for connection purposes
	get_node("container-menu/ip-display-label").text = str(IP.get_local_addresses()[5])


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
		func (new_peer_id) -> void:
			# wait just a moment to begin: workaround for rpc not sending on a brand-new object
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			# call func adding characters of previously connected machines 
			# at new_peer_id and give connectedPeerIds as an argument
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			
			# add own character, not duplicating after the rpc_id call
			add_player_character(new_peer_id)
	)


func _on_buttonjoin_pressed():
	
	# connect to localhost if testing, otherwise contents of ip enter field
	var stored_ip: String
	if TESTING_LOCAL:
		stored_ip = TEST_ADDRESS
	else:
		stored_ip = get_node("container-menu/ip-enter-field").text
	
	if stored_ip.is_valid_ip_address():
		# hide buttons, show this machine is a client
		get_node("container-network-info/network-role").text = "Client"
		get_node("container-menu").visible = false
		
		# instruct multiplayerPeer to make a client, connect to ADDRESS and listen on PORT
		multiplayerPeer.create_client(stored_ip, PORT)
		
		multiplayer.multiplayer_peer = multiplayerPeer
		get_node("container-network-info/label-peer-id").text = str(multiplayer.get_unique_id())


# when called, instantiate the player scene for a network ID, add instance to scene
func add_player_character(peer_id: int) -> void:
	connected_peer_ids.append(peer_id)
	var player_character := preload("res://scenes/player.tscn").instantiate()
	# each id controls its own character, is its own multiplayer authority
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)


# remotely-callable function 
@rpc
func add_newly_connected_player_character(new_peer_id: int) -> void:
	add_player_character(new_peer_id)

# given array of peer ids, add each as a character
@rpc
func add_previously_connected_player_characters(peer_ids: Array) -> void:
	for peer_id in peer_ids:
		add_player_character(peer_id)

