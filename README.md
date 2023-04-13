# team-wii-tanks-godot-4-networking
Godot 4.0 introduced new tools to synchronize instances of a multiplayer game. 
This repository is to test the new additions and develop a system ready to integrate into the base game.

## UML Diagram

```mermaid
classDiagram
    
    Game --> Player : Instantiates
    Game --> MultiplayerSpawner : Button Signal

    %% these are inbuilt to godot, not sure how to document members
    MultiplayerSpawner --> Ball : Instantiates
    MultiplayerSynchronizers --> Player : Syncs between machines
    MultiplayerSynchronizers --> Ball : Syncs between machines

    class Game{

        - MultiplayerPeer multiplayerPeer
        - Array connected_peer_ids

        - _ready()
        -  _on_buttonhost_pressed()
        -  _on_buttonjoin_pressed()
        -  _on_buttonspawn_pressed()
        - void add_player_character(int new_peer_id)
        - @rpc void add_previously_connected_player_characters(Array peer_ids) 
        - @rpc void add_newly_connected_player_character(int new_peer_id)

    }

    class Ball{
        - Label age_label
        - RandomNumberGenerator random
        + Vector2 position
        + Vector2 linear_velocity
        + Vector2 angular_velocity
        + float inertia
        + float mass 

        - _ready()
        - _physics_process()
    }

    class Player{
        - const int SPEED
        - RandomNumberGenerator random
        + Vector2 position
        + Vector2 velocity

        - _ready()
        - _physics_process()
        + @rpc void remote_set_position(Vector2 position)
    }
```
