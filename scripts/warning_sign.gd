extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

const lines: Array[String] = [
	"Mantenha o sistema seguro!",
	"Mate os vírus e evite que se espalhem pela rede!",
	"Os vírus se alimentam de conexões fracas.",
	"Proteja o sistema com firewalls antes que eles invadam!",
	"Vai!!!"
]

func _unhandled_input(event: InputEvent) -> void:
	if area_2d.get_overlapping_bodies().size() > 0:
		sprite_2d.show()
		if event.is_action_pressed("interact") and not DialogManager.is_message_active:
			sprite_2d.hide()
			DialogManager.start_message(global_position, lines)
	else:
		sprite_2d.hide()
		if DialogManager.is_message_active and DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
