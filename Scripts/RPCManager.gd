extends Node

@onready var Network = $".."

func _ready() -> void:
	Network.player_connected.connect(_on_player_connected)
	Network.player_disconnected.connect(_on_player_disconnected)

func _on_player_connected(id: int) -> void:
	print("Connect: ", id)

func _on_player_disconnected(id: int) -> void:
	print("Disconnect: ", id)
