class_name AudioComponent
extends Node

@export var audios: Dictionary[String, AudioStream]

var streams: Dictionary[String, AudioStreamPlayer2D]

func _ready():
	for audio in audios:
		var audio_player := AudioStreamPlayer2D.new()
		add_child(audio_player)
		audio_player.stream = audios[audio]
		streams[audio] = audio_player
		

func play_audio_stream(audio_name: String, randomize_pitch: Vector2 = Vector2.ZERO):
	if audio_name not in streams.keys():
		return
	
	var audio_player = streams[audio_name]
	
	if audio_player.playing:
		return
		
	if randomize_pitch != Vector2.ZERO:
		audio_player.pitch_scale = Global.rng.randf_range(randomize_pitch.x, randomize_pitch.y)
	
	audio_player.play()

func stop_audio_stream(audio_name: String):
	if audio_name not in streams.keys():
		return
		
	var audio_player = streams[audio_name]
	
	if audio_player.playing:
		audio_player.stop()
