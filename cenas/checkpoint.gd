extends Area2D

var is_active = false
@onready var anim = $AnimatedSprite2D as AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.name != "player" or is_active:
		return
	activate_checkpoint()
		
func activate_checkpoint():
	print("O checkpoint está funcionando patrão")
	anim.play("default")
	is_active = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "raising":
		anim.play()
		
