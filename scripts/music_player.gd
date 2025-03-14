extends Node

@onready var music_player = AudioStreamPlayer.new()

func _ready():
	var music = preload("res://audios/The Weeknd - Save Your Tears (Instrumental).MP3")

	if music is AudioStream:  # Garante que o áudio carregou corretamente
		music.set_loop(true)   # Ativa o loop no stream de áudio

	music_player.stream = music
	music_player.volume_db = -20  # Ajuste o volume se necessário
	add_child(music_player)  # Adiciona o player à cena
	music_player.play()  # Começa a tocar automaticamente
