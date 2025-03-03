extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const HIGH_JUMP_VELOCITY = -550.0
const BULLET_SPEED = 1000.0  
const MAX_AIR_JUMPS = 1  # Quantidade de pulos extras no ar

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jumps = 0
var is_jumping = false

@onready var anim := $anim  

# Aceleração e desaceleração para o movimento
const ACCELERATION = 600.0
const DECELERATION = 800.0
const AIR_CONTROL_FACTOR = 0.6  # Controla o movimento no ar (quanto mais baixo, menos controle)

func _physics_process(delta):
	# Aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Reset de pulos extras ao tocar o chão
	if is_on_floor():
		air_jumps = MAX_AIR_JUMPS
		is_jumping = false

	# Controle de pulo (pequeno e alto)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
		elif air_jumps > 0:
			velocity.y = HIGH_JUMP_VELOCITY
			air_jumps -= 1
			is_jumping = true

	if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
		velocity.y = JUMP_VELOCITY / 2  # Permite um pulo menor ao soltar o botão

	# Movimento permitido no ar e no chão
	var direction = Input.get_axis("move_left", "move_right")

	# Aceleração/desaceleração no chão
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	# Movimento no ar (controle reduzido)
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta * AIR_CONTROL_FACTOR)

	# Troca as animações (bloqueia "run" no ar)
	if is_on_floor():
		if direction != 0:
			anim.play("run")  # Animação de correr
		else:
			anim.play("idle")  # Animação de ficar parado
	else:
		if velocity.y < 0:
			anim.play("jump")  # Animação de pulo
		else:
			anim.play("fall")  # Animação de queda

	# Corrige o espelhamento do personagem dependendo da direção do movimento
	if direction != 0:
		$anim.flip_h = (direction < 0)  # Usa flip_h ao invés de mexer no scale.x


	move_and_slide()
