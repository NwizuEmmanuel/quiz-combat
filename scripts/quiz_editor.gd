extends Control

@onready var question_input = $MarginContainer/HSplitContainer/VBoxContainer/Question 
@onready var option_1_input = $MarginContainer/HSplitContainer/VBoxContainer/Option1 
@onready var option_2_input = $MarginContainer/HSplitContainer/VBoxContainer/Option2
@onready var option_3_input = $MarginContainer/HSplitContainer/VBoxContainer/Option3
@onready var option_4_input = $MarginContainer/HSplitContainer/VBoxContainer/Option4
@onready var answer_input = $MarginContainer/HSplitContainer/VBoxContainer/Answer
@onready var multiple_choice_checkbutton = $MarginContainer/HSplitContainer/VBoxContainer/MultipleChoice  
@onready var questions_item_list = $MarginContainer/HSplitContainer/VBoxContainer2/QuestionsList
@onready var add_update_button = $MarginContainer/HSplitContainer/VBoxContainer/HBoxContainer/AddUpdate
@onready var clear_inputs_button = $MarginContainer/HSplitContainer/VBoxContainer/HBoxContainer/ClearInputs
@onready var delete_button = $MarginContainer/HSplitContainer/VBoxContainer2/HBoxContainer/Delete
@onready var clear_selections_button = $MarginContainer/HSplitContainer/VBoxContainer2/HBoxContainer/ClearSelections

var questions = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_multiple_choice()
	multiple_choice_checkbutton.connect("toggled", toggle_multiple_choice)
	add_update_button.connect("pressed",add_update_question)
	clear_inputs_button.connect("pressed", clear_inputs)
	delete_button.connect("pressed", delete_question)
	clear_selections_button.connect("pressed", clear_questions_item_list_selections)

# deselect all selections
func clear_questions_item_list_selections():
	questions_item_list.deselect_all()

# remove selected question
func delete_question():
	if questions_item_list.is_anything_selected():
		var index = questions_item_list.get_selected_items()[0]
		questions.remove_at(index)
		refresh_questions()

# clear all text inputs
func clear_inputs():
	question_input.clear()
	option_1_input.clear()
	option_2_input.clear()
	option_3_input.clear()
	option_4_input.clear()
	answer_input.clear()

# add new question or update existing question
func add_update_question():
	if multiple_choice_checkbutton.toggled:
		add_multiple_choice()
	elif !multiple_choice_checkbutton.toggled:
		add_identification()
	
	clear_inputs()
	refresh_questions()

# refresh item list for new questions
func refresh_questions():
	questions_item_list.clear()
	for q in questions:
		questions_item_list.add_item(q["question"])

# Both answer in identification and multiple choice are
# in lowercase
func add_identification():
	var question_item = {
		"type": "identification",
		"question": question_input.text.edges(),
		"answer": answer_input.text.strip_edges().to_lower()
	}
	questions.append(question_item)

func add_multiple_choice():
	var option1 = option_1_input.text.strip_edges().to_lower()
	var option2 = option_2_input.text.strip_edges().to_lower()
	var option3 = option_3_input.text.strip_edges().to_lower()
	var option4 = option_4_input.text.strip_edges().to_lower()
	var question_item = {
		"type": "multiple_choice",
		"question": question_input.text.strip_edges(),
		"options": [option1, option2, option3, option4],
		"answer": answer_input.text.strip_edges()
	}
	questions.append(question_item)

# hide text inputs related to multiple choice
func hide_multiple_choice():
	answer_input.show()
	option_1_input.hide()
	option_2_input.hide()
	option_3_input.hide()
	option_4_input.hide()

# toggle text inputs for multiple choice or identification
func toggle_multiple_choice(toggled_on: bool):
	if toggled_on:
		answer_input.hide()
		option_1_input.show()
		option_2_input.show()
		option_3_input.show()
		option_4_input.show()
	else:
		answer_input.show()
		option_1_input.hide()
		option_2_input.hide()
		option_3_input.hide()
		option_4_input.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
