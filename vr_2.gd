extends CharacterBody2D

@export var speed: float = 100.0  # Velocidade do inimigo
@export var gravity: float = 500.0  # Gravidade aplicada ao inimigo
@export var left_limit: float = 100.0  # Limite esquerdo de movimento
@export var right_limit: float = 400.0  # Limite direito de movimento
@export var health: int = 1  # Vida do inimigo (padrão: 1)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_left: RayCast2D = $RayCastLeft
@onready var raycast_right: RayCast2D = $RayCastRight
@onready var particles = $CPUParticles2D  # Nó de partículas para efeito de morte

var direction: int = 1  # 1 para direita, -1 para esquerda
var is_dying: bool = false  # Controle para impedir movimento ao morrer

func _ready() -> void:
	sprite.play("V4")  # Ativa a animação de movimento

func _physics_process(delta: float) -> void:
	if is_dying:
		# Aplica gravidade durante a morte
		velocity.y += gravity * delta
		move_and_slide()
		return  # Evita movimentação normal enquanto morrendo

	# Movimenta o inimigo enquanto está vivo
	velocity.x = direction * speed
	velocity.y = 0  # Evita "cair" enquanto não morrendo
	move_and_slide()

	# Inverte direção se detectar colisão ou limites
	if raycast_left.is_colliding() or raycast_right.is_colliding() or position.x <= left_limit or position.x >= right_limit:
		invert_direction()

func invert_direction() -> void:
	direction *= -1  # Inverte a direção de movimento
	sprite.flip_h = (direction < 0)  # Espelha o sprite horizontalmente

func take_damage(amount: int = 1) -> void:  # Parâmetro com valor padrão
	if is_dying:
		return  # Evita dano múltiplo durante a morte

	health -= amount  # Subtrai o dano da saúde
	if health <= 0:
		die()  # Chama o método de morte, se a saúde chegar a zero ou menos

func die() -> void:
	if is_dying:
		return  # Evita chamar a função múltiplas vezes

	is_dying = true  # Marca o inimigo como morrendo
	sprite.modulate = Color(1, 1, 1)  # Fica branco no impacto
	particles.emitting = true  # Ativa partículas de morte
	velocity = Vector2.ZERO  # Para o movimento horizontal e vertical
	velocity.y = -200  # Dá um impulso inicial para cima

	# Animação de piscar antes de sumir
	for i in range(3):
		sprite.visible = false
		await get_tree().create_timer(0.1).timeout
		sprite.visible = true
		await get_tree().create_timer(0.1).timeout

	await get_tree().create_timer(0.5).timeout  # Espera antes de sumir
	queue_free()  # Remove o inimigo da cena
