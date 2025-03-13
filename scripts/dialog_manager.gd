extends Node

@onready var dialog_box_scene = preload("res://cenas/dialog_box.tscn")
var message_lines: Array[String] = []
var current_line = 0

var dialog_box = null
var dialog_box_position := Vector2.ZERO

var is_message_active := false
var can_advance_message := false

func _ready():
	set_process_unhandled_input(true)  # Garante que sempre receba input

func start_message(position: Vector2, lines: Array[String]) -> Node:
	var new_dialog = dialog_box_scene.instantiate()
	get_tree().root.add_child(new_dialog)
	new_dialog.global_position = position
	new_dialog.display_text(lines)  # Chama a função correta no dialog_box
	
	return new_dialog

func show_text():
	if current_line >= message_lines.size():
		close_dialog()
		return null

	if dialog_box:
		dialog_box.queue_free()  # Remove a caixa de diálogo anterior

	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)

	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])

	can_advance_message = false  # Bloqueia avanço até a linha terminar de ser exibida
	return dialog_box

func _on_all_text_displayed():
	can_advance_message = true  # Agora pode avançar para a próxima linha

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_message") and is_message_active and can_advance_message:
		current_line += 1
		show_text()  # Continua para a próxima linha

func close_dialog():
	is_message_active = false
	current_line = 0

	if dialog_box and is_instance_valid(dialog_box):  # Verifica se o nó ainda existe
		dialog_box.queue_free()
	
	dialog_box = null
