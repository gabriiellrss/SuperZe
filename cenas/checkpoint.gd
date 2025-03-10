extends Area2D

var is_active = false
@onready var anim = $AnimatedSprite2D as AnimatedSprite2D
@onready var quiz_control: Control = $"../perguntas/Control"

func _on_body_entered(body: Node2D) -> void:
	quiz_control.visible = true
	quiz_control.process_mode = Node.PROCESS_MODE_ALWAYS  # 🔥 Reativa os botões

	if body.name != "player" or is_active:
		return
	activate_checkpoint()
		
func activate_checkpoint():
	Globals.current_checkpoint = self
	print("O checkpoint está funcionando patrão")
	anim.play("default")
	is_active = true

#func _on_animated_sprite_2d_animation_finished() -> void:
	#if anim.animation == "raising":
		#anim.play()
		
