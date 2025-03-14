extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -350.0
const HIGH_JUMP_VELOCITY = -300.0
const MAX_AIR_JUMPS = 1  # Quantidade de pulos extras no ar
const BULLET_SCENE = preload("res://cenas/bullet.tscn")

@onready var bullet_position = $bulletPosition
@onready var shoot_cooldown: Timer = $shoot_cooldown

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jumps = 0
var is_jumping = false
var is_shooting = false
var is_shootrun = false
var knockback_vector := Vector2.ZERO

@onready var anim := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var jump_sfx: AudioStreamPlayer = $Jump_sfx
@onready var double_jump_sfx: AudioStreamPlayer = $DoubleJump_sfx
@onready var shot: AudioStreamPlayer = $Shot
@onready var kill: AudioStreamPlayer = $kill
@onready var shot_2d: AudioStreamPlayer2D = $Shot2D

signal player_has_died()

const ACCELERATION = 600.0
const DECELERATION = 800.0
const AIR_CONTROL_FACTOR = 0.6  

func _physics_process(delta):
	# Aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Reset de pulos extras ao tocar o chão
	if is_on_floor():
		air_jumps = MAX_AIR_JUMPS
		is_jumping = false

	# Controle de pulo
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			jump_sfx.play()
		elif air_jumps > 0:
			velocity.y = HIGH_JUMP_VELOCITY
			air_jumps -= 1
			jump_sfx.play()
			is_jumping = true

	if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
		velocity.y = JUMP_VELOCITY / 2  

	# Atualiza se está atirando
	is_shooting = Input.is_action_pressed("shoot")
	if is_shooting and shoot_cooldown.is_stopped():
		shoot_bullet()

	# Movimento
	var direction = Input.get_axis("move_left", "move_right")

	# Atualiza posição do Marker2D para o lado correto
	if direction < 0 and $Marker2D.position.x > 0:
		$Marker2D.position.x *= -1
		$Marker2D2.position.x *= -1
	elif direction > 0 and $Marker2D.position.x < 0:
		$Marker2D.position.x *= -1
		$Marker2D2.position.x *= -1

	# Aceleração e desaceleração no chão
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	# Movimento no ar
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta * AIR_CONTROL_FACTOR)

	# Define se está correndo e atirando
	is_shootrun = direction != 0 and is_shooting

	# Troca de animações
	if is_on_floor():
		if is_shootrun:
			anim.play("shootRun")
		elif direction != 0:
			anim.play("run")
		elif is_shooting:
			anim.play("shoot")
		else:
			anim.play("idle")
	else:
		if velocity.y < 0:
			if air_jumps == 0:
				anim.play("doubleJump")
			elif is_shooting:
				anim.play("shootJump")
			else:
				anim.play("jump")
		elif velocity.y > 0:
			if is_shooting:
				anim.play("shortFall")
			else:
				anim.play("fall")

	# Corrige espelhamento do personagem
	if direction != 0:
		$anim.flip_h = (direction < 0)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if $ray_right.is_colliding():
		take_demage(Vector2(-400, -400))
	elif $ray_left.is_colliding():
		take_demage(Vector2(400, -400))

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_demage(knockback_force := Vector2.ZERO, duration:= 0.25):
	kill.play()
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else: 
		emit_signal("player_has_died")
		queue_free()

	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		anim.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(anim, "modulate", Color(1,1,1,1), duration)

func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()

	# Define direção do bullet
	if sign($Marker2D.position.x) == 1:
		bullet_instance.set_directon(1)
	else:
		bullet_instance.set_directon(-1)
	
	# **Escolhe onde o bullet será spawnado**
	if is_shootrun:
		bullet_instance.global_position = $Marker2D2.global_position
	else:
		bullet_instance.global_position = $Marker2D.global_position
	
	# Adiciona o bullet e inicia cooldown
	add_sibling(bullet_instance)
	shoot_cooldown.start()
	shot_2d.play()
