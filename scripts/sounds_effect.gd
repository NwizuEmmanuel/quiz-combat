extends AudioStreamPlayer

func _process(_delta: float) -> void:
	pass

func play_sound(sound: AudioStream):
	stream = sound
	volume_db = 3.0
	play()
	await finished
