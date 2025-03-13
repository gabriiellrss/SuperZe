extends Control

var resposta_correta_var = ""
var resposta_atual = ""


@onready var text_label: Label = $MarginContainer/label_margin/text_label

@onready var botao_1: Button = $MarginContainer/button_margin/GridContainer/Botao1
@onready var botao_2: Button = $MarginContainer/button_margin/GridContainer/Botao2
@onready var botao_3: Button = $MarginContainer/button_margin/GridContainer/Botao3
@onready var botao_4: Button = $MarginContainer/button_margin/GridContainer/Botao4

signal resposta_correta 
signal resposta_errada

# Este método vai configurar o quiz com a pergunta, opções e resposta correta
func configurar(pergunta, opcoes, resposta):
	var label = text_label  # Acessa o nó Label diretamente
	if label:
		label.text = pergunta  # Atualiza o texto da pergunta no Label
	else:
		print("❌ Erro: Label não encontrado!")

	# Configura os botões com as opções de resposta
	botao_1.text = opcoes[0]
	botao_2.text = opcoes[1]
	botao_3.text = opcoes[2]
	botao_4.text = opcoes[3]


	resposta_correta_var = resposta  # Define a resposta correta

# Função chamada para verificar a resposta
func verificar_resposta(resposta):
	if resposta == resposta_correta_var:
		print("✅ Resposta correta!")
		resposta_correta.emit()  # Emite sinal de resposta correta
		queue_free()
	else:
		print("❌ Resposta errada! Emitindo sinal para reiniciar o jogo...")
		resposta_errada.emit()  # Emite sinal de resposta errada
		queue_free()

# Função chamada para capturar entradas de teclado
func _unhandled_input(event: InputEvent) -> void:
	if event and event.pressed:  # Verifica se o evento foi disparado e a tecla foi pressionada
		if event.is_action_pressed("quiz_opcao_1"):  # Se a tecla associada à ação 'quiz_opcao_1' for pressionada
			_on_BotaoA_pressed()  # Chama a função do botão A
		elif event.is_action_pressed("quiz_opcao_2"):  # Se a tecla associada à ação 'quiz_opcao_2' for pressionada
			_on_BotaoB_pressed()  # Chama a função do botão B
		elif event.is_action_pressed("quiz_opcao_3"):  # Se a tecla associada à ação 'quiz_opcao_3' for pressionada
			_on_BotaoC_pressed()  # Chama a função do botão C
		elif event.is_action_pressed("quiz_opcao_4"):  # Se a tecla associada à ação 'quiz_opcao_3' for pressionada
			_on_BotaoD_pressed()  # Chama a função do botão d
		else:
			print("Tecla pressionada não registrada.")

# Função para a interação com os botões
func _on_BotaoA_pressed():
	verificar_resposta("A")

func _on_BotaoB_pressed():
	verificar_resposta("B")

func _on_BotaoC_pressed():
	verificar_resposta("C")

func _on_BotaoD_pressed():
	verificar_resposta("D")
