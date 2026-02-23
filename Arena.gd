extends Control

@onready var question_richtext_label := $TabContainer/QuestionPage/VBoxContainer/QuestionRichTextLabel
@onready var answer_lineedit := $TabContainer/QuestionPage/VBoxContainer/AnswerInput
@onready var player_bar = $TabContainer/QuestionPage/HBoxContainer/PlayerBarBox/PlayerBar
@onready var boss_bar = $TabContainer/QuestionPage/HBoxContainer/BossBarBox/BossBar
@onready var boss_bar_box = $TabContainer/QuestionPage/HBoxContainer/BossBarBox
@onready var player_bar_box = $TabContainer/QuestionPage/HBoxContainer/PlayerBarBox

@onready var options_box = $TabContainer/QuestionPage/VBoxContainer/OptionsBox
@onready var start_quiz_panel = $TabContainer/EndQuizPage/StartQuizPanel
@onready var start_quiz_title = $TabContainer/EndQuizPage/StartQuizPanel/Title


var questions = []
var total_questions = 0
var current_question = 0
var score = 0
var boss_life = 100
var player_life = 100
var correct_answers = 0
var wrong_answers = 0
var score_percentage = 0
var unattended_questions = 0

func give_player_boss_life():
	player_bar.value = player_life
	boss_bar.value = boss_life


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_questions()
	get_total_question()
	display_question()
	give_player_boss_life()

func _process(_delta: float) -> void:
	if boss_life <= 0.0 or player_life <= 0.0:
		reset_quiz()

func display_question():
	# Check if we've reached the end
	if current_question >= total_questions or (boss_life <= 0.0 or player_life <= 0.0):
		score_percentage = score * (100.0 / total_questions)
		unattended_questions = total_questions - current_question
		var result_text = "[b]Quiz over![/b]\n"
		result_text += "[b]Score:[/b] %.1f%%\n" % score_percentage
		result_text += "[b]Correct answers:[/b] %d\t[b]Wrong answers:[/b] %d\t[b]Unattended question:[/b] %d\n" % [correct_answers,wrong_answers,unattended_questions] 
		result_text += "[b]Total questions:[/b] %d" % total_questions
		start_quiz_title.text = result_text
		#options_box.hide()
		#player_bar_box.hide()
		#boss_bar_box.hide()
		reset_quiz()
		start_quiz_panel.show()
		return
	
	var q = questions[current_question]
	var question_text = ""
		
	
	# Format the question number
	question_text += "[b]Question %d/%d:[/b]\n" % [current_question + 1, total_questions]
	
	# Add the question text
	question_text += q["question"] + "\n\n"
	
	# Check for multiple choice
	if q["type"] == 0:
		var option_a = q["options"][0]
		var option_b = q["options"][1]
		var option_c = q["options"][2]
		var option_d = q["options"][3]
		
		question_text += "[b]Options:[/b]\n"
		question_text += "A. %s\n" % option_a
		question_text += "B. %s\n" % option_b
		question_text += "C. %s\n" % option_c
		question_text += "D. %s\n" % option_d
		answer_lineedit.hide()
		options_box.show()
	# Check for identification
	if q["type"] == 1:
		question_text += "[i](Type your answer)[/i]"
		answer_lineedit.show()
		options_box.hide()
	
	question_richtext_label.text = question_text

func next_question():
	if current_question < total_questions - 1:
		current_question += 1
	else:
		# Reached the end
		current_question = total_questions  # This will trigger the completion message

func get_total_question():
	total_questions = questions.size()
	print("Total questions loaded: ", total_questions)

func load_questions():
	var file_path = "res://quiz_samples/quiz1.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_text)
		
		if error == OK:
			questions = json.data
			# Check if the data has a "questions" field
			if questions.has("questions"):
				questions = questions["questions"]
			else:
				print("JSON doesn't have 'questions' field")
		else:
			print("Failed to parse JSON: ", error)
	else:
		print("Could not open file: ", file_path)

func player_damage():
	var damage_point = 100.0 / total_questions
	boss_life -= damage_point
	boss_bar.value = boss_life


func boss_damage():
	var damage_point = (100.0 / total_questions) * 2
	player_life -= damage_point
	player_bar.value = player_life


func check_answer(selected_option):
	var q = questions[current_question]
	var correct_answer = q["answer"]
	
	if selected_option == correct_answer:
		score += 1
		player_damage()
		correct_answers += 1
	else:
		boss_damage()
		wrong_answers += 1

func reset_quiz():
	current_question = 0
	score = 0
	player_life = 100.0
	boss_life = 100.0
	give_player_boss_life()


func _on_btn_a_pressed() -> void:
	check_answer("a")
	next_question()
	display_question()


func _on_btn_b_pressed() -> void:
	check_answer("b")
	next_question()
	display_question()


func _on_btn_c_pressed() -> void:
	check_answer("c")
	next_question()
	display_question()


func _on_btn_d_pressed() -> void:
	check_answer("d")
	next_question()
	display_question()


func _on_answer_input_text_submitted(new_text: String) -> void:
	check_answer(new_text)
	answer_lineedit.clear()
	next_question()
	display_question()
