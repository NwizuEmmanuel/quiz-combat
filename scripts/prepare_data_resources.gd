extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prepare_player_details()
	prepare_quiz_result()
	

func prepare_player_details():
	var path = "res://data/player_details.res"
	var file = load(path)
	if file == null:
		var player_details = PlayerDetails.new()
		player_details.user_fullname = ""
		ResourceSaver.save(player_details, path)


func prepare_quiz_result():
	var path = "res://data/quiz_result.res"
	var file = load(path)
	if file == null:
		var quiz_result_list_data = QuizResultListData.new()
		quiz_result_list_data.user_fullname = ""
		ResourceSaver.save(quiz_result_list_data, path)
