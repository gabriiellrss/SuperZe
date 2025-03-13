extends Area2D

@export var quiz_scene: PackedScene  # Garante que a cena do Quiz será atribuída no editor

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("player entrou")
		var quiz = quiz_scene.instantiate()  # Cria o Quiz
		var quiz_container = get_tree().current_scene.get_node_or_null("QuizContainer")
		
		if quiz_container:
			quiz_container.add_child(quiz)
			
			# Conectando os sinais ao World (usando Callable)
			quiz.connect("resposta_errada", Callable(get_parent(), "reload_game"))
			quiz.connect("resposta_correta", Callable(get_parent(), "proxima_fase"))
			
			quiz.configurar(
				"Segurança na Internet: Qual é a melhor prática para proteger suas senhas online?",
				[
				"A) Usar a mesma senha para todas as contas", 
				"B) Compartilhar suas senhas com amigos confiáveis", 
				"C) Utilizar senhas fortes e diferentes para cada conta", 
				"D) Armazenar todas as senhas em um arquivo de texto simples"],
				"C"
			)
		else:
			print("Erro: QuizContainer não encontrado na cena!")
