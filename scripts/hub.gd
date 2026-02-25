extends Control

@onready var start_game_btn = $VBox/StartGame
@onready var exit_btn = $VBox/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game_btn.connect("pressed",_on_start_game_btn_pressed)
	exit_btn.connect("pressed", _on_exit_btn_pressed)

func _on_start_game_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit_btn_pressed():
	get_tree().quit()
