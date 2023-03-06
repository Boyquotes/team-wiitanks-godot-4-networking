extends Node2D

# an object that handles various networking tasks
var multiplayerPeer = ENetMultiplayerPeer.new()

# info on what computer to connect to. for development, just loopback to self.
# port number isn't too important unless reserved (past first 1024 is safe)
const PORT = 9999
const ADDRESS = "localhost"


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

func _on_buttonjoin_pressed():
	# hide buttons, show this machine is a client
	get_node("container-network-info/network-role").text = "Client"
	get_node("container-menu").visible = false
	
	# instruct multiplayerPeer to make a client, connect to ADDRESS and listen on PORT
	multiplayerPeer.create_client(ADDRESS, PORT)
	
	multiplayer.multiplayer_peer = multiplayerPeer
	get_node("container-network-info/label-peer-id").text = str(multiplayer.get_unique_id())
	
	


func _on_messageinput_text_submitted(new_text):
	pass # Replace with function body.
