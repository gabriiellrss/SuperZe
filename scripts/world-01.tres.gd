extends Node2D

@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://cenas/player.tscn")
@onready var camera := $camera as Camera2D
@onready var control: Control = $HUD/Control

# Chamado quando o nó entra na árvore da cena
func _ready() -> void:
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(reload_game)
	Globals.player_life = 3

func reload_game():
	if player:
		player.queue_free()  # Remove o jogador antigo
		await get_tree().process_frame  # Aguarda 1 frame para garantir a remoção

	# Criar novo jogador corretamente
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2(100, 100)  # Posição inicial ajustável
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)

	# Resetar tempo e vidas ao reiniciar o jogo
	Globals.player_life = 3
	Globals.respawn_player()
	#control.reset_clock_timer()  # Reinicia o tempo corretamente

	print("Jogo reiniciado! Novo jogador criado.")

func _on_area_danger_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("O player está aqui")
		body.take_demage(Vector2(0, -250))
