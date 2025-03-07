extends Node2D

const WAIT_DURATION := 1.0
@onready var platforma := $plataforma as AnimatableBody2D
@onready var detection_area := $plataforma/Area2D  # Adicione uma Area2D como filha da plataforma

@export var move_speed := 3.0
@export var distance := 200
@export var next_scene_path : String  # Caminho para a próxima cena
@export var vertical_movement := true  # Movimento vertical padrão

var follow := Vector2.ZERO
var initial_position := Vector2.ZERO
var player_inside := false

func _ready() -> void:
	initial_position = platforma.position
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	platforma.position = platforma.position.lerp(follow, 0.1)

func move_platform():
	var move_direction = Vector2.UP * distance if vertical_movement else Vector2.RIGHT * distance
	var duration = move_direction.length() / move_speed
	
	var platform_tween = create_tween()
	platform_tween.tween_property(self, "follow", move_direction, duration).set_trans(Tween.TRANS_SINE)
	platform_tween.tween_interval(WAIT_DURATION)
	platform_tween.finished.connect(_on_elevator_arrived)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_inside = true
		body.hide()  # Faz o player "desaparecer"
		move_platform()

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_inside = false

func _on_elevator_arrived():
	if player_inside and !next_scene_path.is_empty():
		get_tree().change_scene_to_file(next_scene_path)
