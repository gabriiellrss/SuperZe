extends Control

signal resposta_errada  # Criando um sinal customizado

@onready var label_pergunta = $VBoxContainer/Label
@onready var botoes = [
	$VBoxContainer/GridContainer/Botao1,
	$VBoxContainer/GridContainer/Botao2,
	$VBoxContainer/GridContainer/Botao3,
	$VBoxContainer/GridContainer/Botao4
]

var perguntas = [
	{
		"pergunta": "Qual é a capital da França?",
		"opcoes": ["Berlim", "Madri", "Paris", "Lisboa"],
		"correta": 2
	},
	{
		"pergunta": "Qual é o maior planeta do Sistema Solar?",
		"opcoes": ["Terra", "Marte", "Júpiter", "Saturno"],
		"correta": 2
	}
]

var pergunta_atual = 0  # Índice da pergunta atual

func _ready():
	configurar_botoes()
	exibir_pergunta()

func configurar_botoes():
	for i in range(botoes.size()):
		botoes[i].pressed.connect(func(): verificar_resposta(i)) # Conecta os botões ao evento de clique

func exibir_pergunta():
	if pergunta_atual < perguntas.size():
		var pergunta = perguntas[pergunta_atual]
		label_pergunta.text = pergunta["pergunta"]

		for i in range(botoes.size()):
			botoes[i].text = pergunta["opcoes"][i]
			botoes[i].visible = true  # Mostra os botões novamente caso tenham sido escondidos

func verificar_resposta(indice):
	if indice == perguntas[pergunta_atual]["correta"]:
		label_pergunta.text = "✅ Resposta correta!"
	else:
		label_pergunta.text = "❌ Resposta errada! A correta era: " + perguntas[pergunta_atual]["opcoes"][perguntas[pergunta_atual]["correta"]]
		emit_signal("resposta_errada")  # 🔥 Emite o sinal quando o jogador erra
		return  # Para o jogo aqui sem fechar!

	# Avança para a próxima pergunta
	pergunta_atual += 1
	if pergunta_atual < perguntas.size():
		await get_tree().create_timer(1.5).timeout  # Aguarda 1.5 segundos antes de mudar de pergunta
		exibir_pergunta()
	else:
		label_pergunta.text = "🎉 Quiz finalizado!"
		for botao in botoes:
			botao.visible = false  # Esconde os botões ao final do quiz
