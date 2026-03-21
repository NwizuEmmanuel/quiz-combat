extends Node
var player_details = load("res://data/player_details.res") as PlayerDetails


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_details.user_fullname != "":
		%FullnameLineEdit.text = player_details.user_fullname


func _on_save_button_pressed() -> void:
	if %FullnameLineEdit.text != "":
		player_details = PlayerDetails.new()
		player_details.user_fullname = %FullnameLineEdit.text.strip_edges()
		ResourceSaver.save(player_details, "res://data/player_details.res")
		get_tree().change_scene_to_file("res://scenes/quiz_play.tscn")
	else:
		%AcceptDialog.title = "WARNING"
		%AcceptDialog.dialog_text = "USER FULL NAME IS EMPTY"
		%AcceptDialog.popup_centered()
