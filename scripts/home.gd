extends Node

@onready var start_game_button = $VBoxContainer/StartGame
@onready var create_quiz_button = $VBoxContainer/CreateQuiz
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_quiz_button.connect("pressed", create_quiz)

func create_quiz():
	get_tree().change_scene_to_file("res://scenes/quiz_editor.tscn")

func start_game():
	pass
