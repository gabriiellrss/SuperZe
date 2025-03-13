extends Area2D

@export var damage := 2
@export var knockback_force := Vector2(250, -200)  # Knockback para trás e para cima

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage, knockback_force)
