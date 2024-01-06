extends Node

@onready var Network = $".."

func _ready() -> void:
	Network.player_chat.connect(_on_send_chat)

func _on_send_chat(id: int, msg: String) -> void:
	Network.rpc_notify_all.rpc(msg)
