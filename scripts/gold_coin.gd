extends Area2D

@onready var coin_audio: AudioStreamPlayer = $coinAudio
var coins := 1
@export var coins_score := 25
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	coin_audio.play()
	await $collision.call_deferred('queue_free()')
	Globals.score += coins_score
	Globals.coins += coins
	print(Globals.coins)
	queue_free()
