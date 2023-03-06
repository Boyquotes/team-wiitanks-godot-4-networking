extends Node2D

# an object that handles various networking tasks
var multiplayerPeer = ENetMultiplayerPeer.new()

# info on what computer to connect to. for development, just loopback to self.
# port number isn't too important unless reserved (past first 1024 is safe)
const PORT = 9999
const ADDRESS = "localhost"
