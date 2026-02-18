extends Control

@onready var question_richtext_label := $VBoxContainer/QuestionRichTextLabel
@onready var answer_lineedit := $VBoxContainer/AnswerInput

var questions = []
var total_questions = 0
var current_question = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_questions()
	get_total_question()
	display_question()

func _process(_delta: float) -> void:
	pass
	# Check for input to advance to next question
	#if Input.is_action_just_pressed("option_a") or \
	   #Input.is_action_just_pressed("option_b") or \
	   #Input.is_action_just_pressed("option_c") or \
	   #Input.is_action_just_pressed("option_d"):
		#next_question()
		#display_question()

func display_question():
	# Check if we've reached the end
	if current_question >= total_questions:
		question_richtext_label.text = "Quiz Complete! Thanks for playing!"
		reset_quiz()
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
		
	# Check for identification
	if q["type"] == 1:
		question_text += "[i](Type your answer)[/i]"
	
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

func check_answer(selected_option):
	var q = questions[current_question]
	var correct_answer = q["answer"]
	
	if selected_option == correct_answer:
		score += 1
		print("Correct! Score: ", score)
	else:
		print("Wrong! Score: ", score)

func _input(event):
	var q = questions[current_question]
	if q["type"] == 0:
		answer_lineedit.hide()
		if event.is_action_pressed("option_a"):
			check_answer("a")
			next_question()
			display_question()
		elif event.is_action_pressed("option_b"):
			check_answer("b")
			next_question()
			display_question()
		elif event.is_action_pressed("option_c"):
			check_answer("c")
			next_question()
			display_question()
		elif event.is_action_pressed("option_d"):
			check_answer("d")
			next_question()
			display_question()
	elif q["type"] == 1:
			answer_lineedit.show()
			if event.is_action_pressed("check_identification"):
				var answer = answer_lineedit.text
				check_answer(answer)
				next_question()
				display_question()
	
	
func reset_quiz():
	current_question = 0
	score = 0
	#display_question()
