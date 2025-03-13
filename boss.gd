extends CharacterBody2D

@export var health := 1
@export var bounce_force := 600.0
@export var damage_on_jump := 15
@export var movement_speed := 150.0
@export var attack_cooldown := 2.0
@export var gravity := 980.0
@export var attack_damage := 10  # Reduzi o dano para evitar hit kill
@export var attack_push_force := 300.0

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var attack_timer = $AttackTimer
@onready var detection_area = $DetectionArea
@onready var jump_particles = $JumpParticles
@onready var attack_area = $AttackArea

var is_activated := false
var can_attack := true

func _ready():
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	attack_timer.wait_time = attack_cooldown
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	anim.play("idle")

func _physics_process(delta):
	if !is_activated or health <= 0:
		velocity.x = 0
		velocity.y += gravity * delta
		move_and_slide()  # Usando apenas move_and_slide()
		return

	# Aplicar gravidade
	velocity.y += gravity * delta

	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * movement_speed
		anim.flip_h = direction.x < 0  # Ajustar direção do sprite

		if is_on_floor():
			velocity.y = 0  # Resetar velocidade vertical quando no chão

	# Movimenta o Boss
	move_and_slide()  # Sem argumentos

	if can_attack and global_position.distance_to(player.global_position) < 150:
		start_attack()

func start_attack():
	can_attack = false
	anim.play("attack1")
	velocity = Vector2.ZERO  # Pausar movimento durante o ataque
	
	await get_tree().create_timer(0.3).timeout  # Momento do golpe
	apply_attack_damage()
	
	await anim.animation_finished
	attack_timer.start()
	can_attack = true

func apply_attack_damage():
	if attack_area and attack_area.get_overlapping_bodies():
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				if body.has_method("take_damage"):
					body.take_damage(attack_damage)  # Aplica dano com o valor reduzido
					var push_dir = (body.global_position - global_position).normalized()
					body.velocity = push_dir * attack_push_force  # Empurra o jogador para trás

func take_damage(amount: int):
	if health <= 0:
		return
	
	health -= amount
	anim.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color.WHITE
	
	if health <= 0:
		die()

func die():
	anim.play("death")
	set_collision_layer_value(2, false)  # Desativar colisões
	$Hitbox/CollisionShape2D.disabled = true
	await anim.animation_finished
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("Player") and body.velocity.y > 0:
		take_damage(damage_on_jump)
		body.velocity.y = -bounce_force
		if jump_particles:
			jump_particles.emitting = true

func _on_attack_timer_timeout():
	can_attack = true

func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		player = body
		is_activated = true
		attack_timer.start()
