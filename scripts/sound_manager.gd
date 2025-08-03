extends Node2D

var sounds = [
	preload("res://assets/audios/soundtrack/soundtrack1.wav"),
	preload("res://assets/audios/soundtrack/soundtrack2.wav")
]

var stream_player: AudioStreamPlayer
var last_played = null

func _ready():
	
	stream_player = AudioStreamPlayer.new()
	add_child(stream_player)
	stream_player.volume_db = -10
	

func _process(delta: float) -> void:
	
	if stream_player.playing:
		return
		
	var pick = sounds.pick_random()
	
	if last_played == pick:
		return
		
	last_played = pick
	stream_player.stream = pick
	stream_player.play()
		
