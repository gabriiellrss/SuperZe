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
				"Códigos maliciosos (Malware): Qual é a principal função de um vírus de computador?",
				[
				"A) Ajudar a aumentar a velocidade do sistema", 
				"B) Espionar as atividades do usuário sem consentimento", 
				"C) Corrigir falhas no sistema automaticamente", 
				"D) Infectar e danificar arquivos ou sistemas"],
				"D"
			)
		else:
			print("Erro: QuizContainer não encontrado na cena!")
