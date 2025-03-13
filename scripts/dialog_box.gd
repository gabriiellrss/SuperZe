extends MarginContainer

@onready var text_label: Label = $label_margin/text_label
@onready var letter_timer_display: Timer = $letter_timer_display

const MAX_WIDTH = 256

var text_lines: Array[String] = []
var current_line = 0
var letter_index = 0

var letter_display_timer := 0.07
var space_display_timer := 0.05
var punctuation_display_timer := 0.2

signal text_display_finished()

func _ready():
	letter_timer_display.timeout.connect(_on_letter_timer_display_timeout)

func display_text(lines: Array[String]):
	text_lines = lines
	current_line = 0
	show_text()

func show_text():
	if current_line >= text_lines.size():
		queue_free()  # Fecha o diálogo ao terminar todas as falas
		return

	text_label.text = ""
	letter_index = 0
	display_letter()

func display_letter():
	if letter_index >= text_lines[current_line].length():
		text_display_finished.emit()
		return
	
	text_label.text += text_lines[current_line][letter_index]
	letter_index += 1
	
	match text_lines[current_line][letter_index - 1]:
		"!", "?", ",", ".":
			letter_timer_display.start(punctuation_display_timer)
		" ":
			letter_timer_display.start(space_display_timer)
		_:
			letter_timer_display.start(letter_display_timer)

func _on_letter_timer_display_timeout() -> void:
	display_letter()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("advance_message"):
		current_line += 1
		show_text()
