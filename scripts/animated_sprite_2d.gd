extends CharacterBody2D

@export var speed: float = 1000.0  # Velocidade da bala
var direction := Vector2.ZERO

func _ready():
	set_velocity(direction * speed)  # Define a velocidade inicial

func _physics_process(delta):
	pass  # Move a bala automaticamente

	# Se a bala sair da tela, remover ela
	if not get_viewport_rect().has_point(global_position):
		queue_free()
