extends Node

@onready var question_text_text_edit = %QuestionTextTextEdit
@onready var option_1_line_edit = %Option1LineEdit
@onready var option_2_line_edit = %Option2LineEdit
@onready var option_3_line_edit = %Option3LineEdit
@onready var option_4_line_edit = %Option4LineEdit
@onready var identification_answer_line_edit = %IdentificationAnswerLineEdit
@onready var multiple_choice_answer_spin_box = %MultipleChoiceAnswerSpinBox
@onready var points_spin_box = %PointsSpinBox
@onready var duration_spin_box = %DurationSpinBox
@onready var question_type_option_button = %QuestionTypeOptionButton
@onready var quiz_editor_item_list = %QuizEditorItemList
@onready var quiz_editor_dialog = %QuizEditorDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list_questions()

func list_questions():
	var file = load(QuizData.quiz_path) as Questions
	quiz_editor_item_list.clear()
	for i in file.questions:
		quiz_editor_item_list.add_item(i.text) 

func add_multiple_choice():
	pass

func add_identification():
	if question_text_text_edit.text == "":
		quiz_editor_item_list.title = "question is empty"
		quiz_editor_item_list.popup_centered(Vector2i(200,100))
		return
	if identification_answer_line_edit.text == "":
		quiz_editor_item_list.title = "identification answer is empty"
		quiz_editor_item_list.popup_centered(Vector2i(400,100))
		return

	var item = QuestionItem.new()
	item.question_type = QuestionItem.QuestionType.IDENTIFICATION
	item.text = question_text_text_edit.text
	item.correct_answer = identification_answer_line_edit.text
	item.points = points_spin_box.value
	item.duration = duration_spin_box.value
	
	var q = Questions.new()
	q.title = QuizData.quiz_title
	q.questions.append(item)
	ResourceSaver.save(q, QuizData.quiz_path)
	list_questions()
	

func disable_multiple_choice():
	option_1_line_edit.editable = false
	option_2_line_edit.editable = false
	option_3_line_edit.editable = false
	option_4_line_edit.editable = false
	multiple_choice_answer_spin_box.editable = false

func enable_multiple_choice():
	option_1_line_edit.editable = true
	option_2_line_edit.editable = true
	option_3_line_edit.editable = true
	option_4_line_edit.editable = true
	multiple_choice_answer_spin_box.editable = true

func enable_identification():
	identification_answer_line_edit.editable = true

func disable_identification():
	identification_answer_line_edit.editable = false

func _on_question_type_option_button_item_selected(index: int) -> void:
	if index == 0:
		disable_identification()
		enable_multiple_choice()
	elif index == 1:
		disable_multiple_choice()
		enable_identification()


func _on_add_button_pressed() -> void:
	var index = question_type_option_button.get_selected_id()
	if index == -1:
		quiz_editor_dialog.title = "choose question type"
		quiz_editor_dialog.popup_centered(Vector2i(250,100))
	else:
		add_identification()
