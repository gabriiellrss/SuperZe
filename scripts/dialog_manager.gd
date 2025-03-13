extends Node

@onready var dialog_box_scene = preload("res://cenas/dialog_box.tscn")
var message_lines : Array[String] = []
var current_line = 0

var dialog_box
var dialog_box_position := Vector2.ZERO

var is_message_active := false
var can_advance_message := false

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return
		
	message_lines = lines
	dialog_box_position = position
	show_text()
	is_message_active = true

func show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])
	can_advance_message = true
	
func _on_all_text_displayed():
	can_advance_message = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_message") and is_message_active and can_advance_message:
		current_line += 1
		if current_line >= message_lines.size():
			is_message_active = false
			current_line = 0
			dialog_box.queue_free() # Só liberar após verificar que é o fim
			return
		dialog_box.queue_free()  # Liberar antes de chamar o próximo texto
		show_text()
