extends Node

@onready var file_dialog = $FileDialog
@onready var add_button = $VBox/HBox/SelectQuizFile
@onready var delete_button = $VBox/HBox/DeleteQuiz
@onready var item_list = $VBox/ItemList
@onready var overwrite_dialog = $OverwriteDialog

var save_dir := "user://quizzes/"
var pending_source_path : String = ""
var pending_target_path: String = ""


func _ready() -> void:
	add_button.connect("pressed", _on_add_button_pressed)
	delete_button.connect("pressed", _on_delete_quiz_pressed)
	overwrite_dialog.confirmed.connect(_on_overwrite_confirmed)
	item_list.connect("item_activated",_on_item_activited)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	
	# Ensure folder exists
	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(save_dir)
	)
	
	refresh_file_list()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("go_to_hub"):
		get_tree().change_scene_to_file("res://scenes/HUB.tscn")

# SELECT FILE
func _on_add_button_pressed() -> void:
	file_dialog.popup_centered()

func _on_file_dialog_file_selected(path: String) -> void:
	print("Selected file: ", path)
	var file_name = path.get_file()
	var target_path = save_dir + file_name
	var absolute_target = ProjectSettings.globalize_path(target_path)
	
	if FileAccess.file_exists(absolute_target):
		# File exists -> ask confirmation
		pending_source_path = path
		pending_target_path = target_path
		
		overwrite_dialog.dialog_text = "File already exists. \nDo you want to overwrite it?"
		overwrite_dialog.popup_centered()
	else:
		save_file(path, target_path)
		refresh_file_list()  


# CONFIRM OVERWRITE
func _on_overwrite_confirmed():
	save_file(pending_source_path, pending_target_path)
	refresh_file_list()

# SAVE FILE
func save_file(source_path: String, target_path: String):
	DirAccess.copy_absolute(
		source_path,
		ProjectSettings.globalize_path(target_path)
	)
	print("Saved to: ", target_path)

# LIST FILES
func refresh_file_list():
	item_list.clear()
	
	var dir = DirAccess.open(save_dir)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var filename = dir.get_next()
	
	while filename != "":
		if not dir.current_is_dir():
			item_list.add_item(filename)
		filename = dir.get_next()
	dir.list_dir_end()

# CLICK ITEM
func _on_item_activited(index: int) -> void:
	var file_name = item_list.get_item_text(index)
	var full_path = save_dir + file_name
	Global.quiz_file_path = full_path
	get_tree().change_scene_to_file("res://scenes/quiz.tscn")
	print("Selected file path: ", full_path)

# DELETE FILE
func _on_delete_quiz_pressed() -> void:
	var selected = item_list.get_selected_items()
	if selected.is_empty():
		print("No file selected")
		return

	var index = selected[0]
	var file_name = item_list.get_item_text(index)
	var full_path = save_dir + file_name

	var dir = DirAccess.open(save_dir)
	if dir:
		dir.remove(file_name)
		print("Deleted: ", full_path)

	refresh_file_list()
