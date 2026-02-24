extends Control

@onready var result_label := $root/richtext_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var result_text = ""
	if Global._score == Global._total_questions:
		result_text += "[b]Quiz over! \t You Win![/b]\n"
	else:
		result_text += "[b]Quiz over! \t You Lose![/b]\n"
	result_text += "[b]Score:[/b] %d/%d\n" % [Global._score, Global._total_questions]
	result_label.text = result_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/quiz.tscn")
