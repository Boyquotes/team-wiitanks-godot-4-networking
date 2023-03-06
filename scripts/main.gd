extends Node2D

# an object that handles various networking tasks
var multiplayerPeer = ENetMultiplayerPeer.new()

# info on what computer to connect to. for development, just loopback to self.
# port number isn't too important unless reserved (past first 1024 is safe)
const PORT = 9999
const ADDRESS = "localhost"


func _on_buttonhost_pressed():
	get_node("container-network-info/network-role").text = "Server"
	get_node("container-menu").visible = false


func _on_buttonjoin_pressed():
	get_node("container-network-info/network-role").text = "Client"
	get_node("container-menu").visible = false


func _on_messageinput_text_submitted(new_text):
	pass # Replace with function body.
