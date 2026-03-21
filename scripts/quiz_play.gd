extends Node

var quiz_file = load(QuizData.quiz_path) as Questions
var quiz_items: Array[QuestionItem] = quiz_file.questions
var total_questions = 0
var current = 0
var score = 0
var  MAX_LIFE = 100.0
var GRACE_POINT = 0.5
var player_life = 0.0
var boss_life = 0.0
var defeat_boss_point = 0.0
var multiple_choice_answer = 0
var identification_answer = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_questions = quiz_items.size()
	display_question()
	player_life = MAX_LIFE
	boss_life = MAX_LIFE
	update_life()

func set_defeat_boss_point():
	# set defeat boss point with remaining player life after
	# boss is defeated
	if boss_life <= 0.0:
		defeat_boss_point = player_life
	%DefeatBossPoint.text = "Defeat Boss Point: %d" % defeat_boss_point

func update_life():
	%BossLifeBar.value = boss_life
	%PlayerLifeBar.value = player_life

func display_question():
	if current < total_questions:
		var q = quiz_items[current]
		var question_text = "[b]%d: %s[/b] \n\n" % [current + 1, q.text]
		var options_text = ""  
		
		if q.question_type == QuestionItem.QuestionType.MULTIPLE_CHOICE:
			options_text += "A: %s\n" %q.options[0]
			options_text += "B: %s\n" %q.options[1]
			options_text += "C: %s\n" %q.options[2]
			options_text += "D: %s\n" %q.options[3]
			%OptionsText.text = options_text
			%IdentificationAnswerBox.hide()
			%MultipleChoiceOptionsBox.show()
			%OptionsText.show()
		elif q.question_type == QuestionItem.QuestionType.IDENTIFICATION:
			%IdentificationAnswerBox.show()
			%MultipleChoiceOptionsBox.hide()
			%OptionsText.hide()
		%QuestionText.text = question_text
		%QuizTimer.start(q.time_limit)
	else:
		save_quiz_data()
		get_tree().change_scene_to_file("res://scenes/quiz_result.tscn")

func answer_feedback(mssg:String):
	%QuizDialog.title = "INFO"
	%QuizDialog.dialog_text = mssg
	%QuizDialog.popup_centered()

func check_answer():
	var failed_quiz = {}
	if current < total_questions:
		var q = quiz_items[current]
		if q.question_type == QuestionItem.QuestionType.MULTIPLE_CHOICE:
			if q.correct_option == multiple_choice_answer:
				score += 1
				deal_boss_damage()
			else:
				failed_quiz = {"id": current, "choice": multiple_choice_answer}
				QuizData.failed_questions.append(failed_quiz)
				deal_player_damage()
		elif q.question_type == QuestionItem.QuestionType.IDENTIFICATION:
			if identification_answer.to_upper() in q.correct_answer:
				score += 1
				deal_boss_damage()
			else:
				deal_player_damage()
				failed_quiz = {"id": current, "choice": identification_answer.to_upper()}
				QuizData.failed_questions.append(failed_quiz)

func next_question():
	current += 1
	display_question()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%TimerLabel.text = "TIME: %d" % %QuizTimer.time_left
	%ScoreLabel.text = "SCORE: %d/%d" % [score,total_questions]
	update_life()
	timer_label_change_color_timer_stopped()
	set_defeat_boss_point()
	QuizData.total_questions = total_questions
	QuizData.score = score
	QuizData.defeat_boss_point = defeat_boss_point


func deal_damage() -> float:
	var result = 0
	if !%QuizTimer.is_stopped():
		var time_left = %QuizTimer.time_left + 1
		var damage_point = MAX_LIFE / (total_questions - GRACE_POINT)
		result = damage_point + time_left
	return result

func timer_label_change_color_timer_stopped():
	if %QuizTimer.is_stopped():
		%TimerLabel.add_theme_color_override("font_color",Color.RED)
	else:
		%TimerLabel.add_theme_color_override("font_color",Color.YELLOW)

func deal_boss_damage():
	boss_life -= deal_damage()

func deal_player_damage():
	player_life -= deal_damage()

func convert_multiple_choice_answer(ans: int) -> String:
	var result = ""
	if ans == 1:
		result = "A"
	elif ans == 2:
		result = "B"
	elif ans == 3:
		result = "C"
	elif ans == 4:
		result = "D"
	return result


func quiz_result() -> String:
	var total_question = QuizData.total_questions
	var result_text = ""
	result_text += "SCORE: %d/%d\n" % [score,total_question]
	result_text += "DEFEAT BOSS POINT: %d\n" % defeat_boss_point
	result_text += "[b]Quiz[/b]\n"
	for i in range(quiz_items.size()):
		if quiz_items[i].question_type == QuestionItem.QuestionType.MULTIPLE_CHOICE:
			result_text += str(i+1)+": "+quiz_items[i].text+"\n\n"
			result_text += "A: "+quiz_items[i].options[0]+"\n"
			result_text += "B: "+quiz_items[i].options[1]+"\n"
			result_text += "C: "+quiz_items[i].options[2]+"\n"
			result_text += "D: "+quiz_items[i].options[3]+"\n"
			for j in QuizData.failed_questions:				
				if j.id == i:
					result_text += "YOUR CHOICE: "+convert_multiple_choice_answer(j.choice)+"\n"
					result_text += "[color=red]You failed this question\n[/color]"
					break
			result_text += "CORRECT: "+convert_multiple_choice_answer(quiz_items[i].correct_option)+"\n\n"
		elif quiz_items[i].question_type == QuestionItem.QuestionType.IDENTIFICATION:
			result_text += str(i+1)+": "+quiz_items[i].text+"\n\n"
			for k in QuizData.failed_questions:
				if k.id == i:
					result_text += "YOUR CHOICE: "+k.choice+"\n"
					result_text += "[color=red]You failed this question\n[/color]"
					break
			result_text += "CORRECT: "+quiz_items[i].correct_answer+"\n\n"
	return result_text

func save_quiz_data():
	# 2. Format the timestamp (Removing 'T' and ':')
	var raw_time = Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	var file_path = "res://data/quiz_result.res"
	var quiz_result_list_data = load(file_path) as QuizResultListData
	var player_details = load("res://data/player_details.res") as PlayerDetails
	var quiz_result_data = QuizResultData.new()
	quiz_result_data.timestamp = raw_time
	quiz_result_data.quiz = quiz_result()
	quiz_result_list_data.user_fullname = player_details.user_fullname
	quiz_result_list_data.quizzes.append(quiz_result_data)
	
	ResourceSaver.save(quiz_result_list_data, file_path)

func _on_option_a_pressed() -> void:
	multiple_choice_answer = 1
	check_answer()
	next_question()


func _on_option_b_pressed() -> void:
	multiple_choice_answer = 2
	check_answer()
	next_question()


func _on_option_c_pressed() -> void:
	multiple_choice_answer = 3
	check_answer()
	next_question()


func _on_option_d_pressed() -> void:
	multiple_choice_answer = 4
	check_answer()
	next_question()


func _on_identification_answer_line_edit_text_submitted(new_text: String) -> void:
	identification_answer = new_text
	check_answer()
	next_question()
	%IdentificationAnswerLineEdit.clear()
