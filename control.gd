extends Control

@onready var coins_counter: Label = $container/coinsContainer/coinsCounter as Label
@onready var score_counter_2: Label = $container/scoreContainer/scoreCounter2 as Label
@onready var time_counter_2: Label = $container/timeContainer/timeCounter2 as Label
@onready var life_counter: Label = $container/lifeContainer/lifeCounter as Label
@onready var clock_time: Timer = $clock_time as Timer

var minutes = 0
var seconds = 0
@export_range(0,5) var default_minutes := 1
@export_range(0,59) var default_seconds := 0

signal time_is_up()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter_2.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	time_counter_2.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter_2.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)

	if minutes == 0 and seconds == 0:
		reset_clock_timer()
		emit_signal("time_is_up")
		print("Sinal emitido")


func _on_clock_time_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	time_counter_2.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
		
func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
	
