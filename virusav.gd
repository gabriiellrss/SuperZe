extends CharacterBody2D

@export var enemy_score := 100  # Pontos ao derrotar o inimigo
@export var speed: float = 100.0  # Velocidade do inimigo
@export var gravity: float = 500.0  # Gravidade aplicada quando ele cai

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_left: RayCast2D = $RayCastLeft
@onready var raycast_right: RayCast2D = $RayCastRight
@onready var particles = $CPUParticles2D  # Nó de partículas
@onready var hitbox: Area2D = $Hitbox  # Área de detecção para o jogador pular

var direction: int = 1  # 1 para direita, -1 para esquerda
var is_dying: bool = false  # Controle para evitar movimento enquanto cai

func _ready() -> void:
	sprite.play("V4")  # Ativa a animação
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)  # Conecta o sinal de colisão
	else:
		push_error("Hitbox não encontrada! Verifique o nó 'Hitbox' na cena.")

func _physics_process(delta: float) -> void:
	if is_dying:
		velocity.y += gravity * delta  # Aplica gravidade para cair
		move_and_slide()
		return  # Sai da função para não mover normalmente

	# Move o inimigo para frente normalmente
	velocity.x = direction * speed
	move_and_slide()  # Processa o movimento antes de verificar colisões

	# Verifica se bateu na parede ou se algum dos RayCasts detectou algo
	if is_on_wall() or (direction == 1 and raycast_right.is_colliding()) or (direction == -1 and raycast_left.is_colliding()):
		direction *= -1  # Inverte a direção do movimento
		sprite.scale.x *= -1  # Espelha o sprite para o outro lado

func _on_hitbox_body_entered(body: Node2D) -> void:
	# Verifica se o corpo que entrou na hitbox é o jogador
	if body.is_in_group("Player") and body.velocity.y > 0:  # Jogador está caindo
		take_damage()  # Inimigo toma dano
		body.velocity.y = -300  # Aplica um pequeno impulso para cima no jogador

func take_damage():
	if is_dying:
		return

	is_dying = true  # Marca que o inimigo está morrendo
	sprite.modulate = Color(1, 0, 0)  # Fica vermelho no impacto
	particles.emitting = true  # Ativa as partículas
	velocity.x = 0  # Para o movimento horizontal
	velocity.y = 250  # Dá um impulso inicial para baixo (queda mais rápida)

	# Faz o inimigo piscar rapidamente antes de sumir
	for i in range(3):  # Pisca 2 vezes bem rápido
		sprite.visible = false
		await get_tree().create_timer(0.02).timeout
		sprite.visible = true
		await get_tree().create_timer(0.02).timeout

	await get_tree().create_timer(0.2).timeout  # Pequena espera antes de sumir
	Globals.score += enemy_score  # Adiciona pontos ao score global
	queue_free()  # Remove o inimigo da cena
