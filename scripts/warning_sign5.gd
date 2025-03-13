extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

const lines: Array[String] = [
	"Um vírus de computador é um tipo de malware", 
	"que se infiltra no sistema, causando danos a arquivos e dados.",
	" Isso é feito com a ajuda de ,", 
	"Ele pode se espalhar para outros dispositivos",
	"e roubar informações importantes,",
	"como senhas ou dados bancários.",
]

var dialog_instance = null  # Armazena o diálogo localmente

func _unhandled_input(event: InputEvent) -> void:
	if area_2d.get_overlapping_bodies().size() > 0:
		sprite_2d.show()
		if event.is_action_pressed("interact") and dialog_instance == null:
			sprite_2d.hide()
			dialog_instance = DialogManager.start_message(global_position, lines)
	else:
		sprite_2d.hide()
		if dialog_instance != null:
			dialog_instance.queue_free()
			dialog_instance = null
