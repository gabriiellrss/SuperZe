extends Node

var coins := 0
var score := 0

var player = null
var current_checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
