extends Node

# Server setup
const PORT: int = 7000
const DEFAULT_SERVER_IP: String = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS: int = 60

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	start_server()

signal player_connected(id: int)
signal player_disconnected(id: int)
signal player_info(id: int, info: String)
signal player_chat(id: int, msg: String)

# Own methods
#region
func start_server() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		print(error)
		return
	multiplayer.multiplayer_peer = peer
	print("Server started")
#endregion

# Signal subscription methods
#region
func _on_player_connected(id: int) -> void:
	player_connected.emit(id)

func _on_player_disconnected(id: int) -> void:
	player_disconnected.emit(id)
#endregion

# RPCs
#region
@rpc("authority", "reliable")
func rpc_notify_all(msg: String) -> void:
	pass

@rpc("authority", "reliable")
func rpc_notify_peer(id: int, msg: String) -> void:
	pass

@rpc("any_peer", "reliable")
func rpc_send_player_info(info: String) -> void:
	var id: int = multiplayer.get_remote_sender_id()
	player_info.emit(id, info)

@rpc("any_peer", "reliable")
func rpc_send_chat(msg: String) -> void:
	var id: int = multiplayer.get_remote_sender_id()
	player_chat.emit(id, msg)
#endregion
