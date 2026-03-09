extends Node

var question_type = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_multiple_choice_button_pressed() -> void:
	question_type = "multiple_choice"
	get_tree().change_scene_to_file("res://scenes/multiple_choice_editor.tscn")  
	print(question_type)


func _on_identification_button_pressed() -> void:
	question_type = "identification"
	print(question_type)
