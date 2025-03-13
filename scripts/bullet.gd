extends Area2D

var bullet_speed := 500.0
var direction := 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += bullet_speed * direction * delta


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free() 

func set_directon(dir):
	direction = dir
	if dir < 0:
		$AnimatedSprite2D.set_flip_h(true)
	else:
		$AnimatedSprite2D.set_flip_h(false)
