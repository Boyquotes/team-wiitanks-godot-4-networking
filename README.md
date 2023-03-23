# team-wii-tanks-godot-4-networking
Godot 4.0 introduced new tools to synchronize instances of a multiplayer game. 
This repository is to test the new additions and develop a system ready to integrate into the base game.

## MultiplayerSynchronizer
This node is a low-code solution new to Godot 4.0. By adding it to a scene's tree, you may synchronize certain properties of that scene across a network.
This node promises to automate the work of manually calling methods over RPC to adjust and sync the properties (positions) of objects in a larger scene.
This scene will feature a bouncing ball that uses this node to synchronize position over all game instances on a network.

## MultiplayerSpawner
This node instantiates and maintains replication of spawned scenes. 
