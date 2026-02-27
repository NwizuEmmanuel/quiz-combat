extends AudioStreamPlayer


@onready var ui_sounds = $UISounds

func play_sound(sound: AudioStream):
	stream = sound
	play()
	await finished
