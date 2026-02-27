extends CanvasLayer

@onready var start_game_btn = $Panel/VBox/StartGame
@onready var exit_btn = $Panel/VBox/Exit

var busy = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game_btn.connect("pressed",_on_start_game_btn_pressed)
	start_game_btn.connect("mouse_entered", play_hover_sound) 
	exit_btn.connect("pressed", _on_exit_btn_pressed)
	exit_btn.connect("mouse_entered", play_hover_sound)

func _on_start_game_btn_pressed():
	if busy:
		return
	busy = true
	SoundsEffect.play_sound(preload("res://sounds/button_press.mp3"))  
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	busy = true

func _on_exit_btn_pressed():
	if busy:
		return
	busy = true
	SoundsEffect.play_sound(preload("res://sounds/button_press.mp3"))
	get_tree().quit()

func play_hover_sound():
	SoundsEffect.play_sound(preload("res://sounds/button_hover.mp3"))
