extends Node2D

@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://cenas/player.tscn")
@onready var camera := $camera as Camera2D
@onready var control: Control = $HUD/Control
@onready var quiz_control: Control = $perguntas/Control

# Chamado quando o nó entra na árvore da cena
func _ready() -> void:
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(reload_game)
	Globals.player_life = 3
	
	# Conexão para quando o Quiz emite os sinais
	var quiz_node = get_tree().current_scene.get_node_or_null("QuizContainer")
	if quiz_node:
		quiz_node.connect("resposta_errada", Callable(self, "reload_game"))
		quiz_node.connect("resposta_correta", Callable(self, "proxima_fase"))

# Adicione a nova função para caso de resposta correta
func proxima_fase():
	print("✅ Passando para a próxima fase!") # Implementar lógica aqui para prosseguir com o jogo

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

func _on_limbo_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "player":
		print("O player está aqui")
		body.queue_free()
		await get_tree().create_timer(2.0).timeout
		reload_game()
