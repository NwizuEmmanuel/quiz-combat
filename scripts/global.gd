extends Node

var _score = 0
var _total_questions = 0
var quiz_file_path = ""
var level = 1

func get_data(score: int, total_questions: int):
	_score = score
	_total_questions = total_questions
