extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prepare_all_player_stats()
	
func prepare_all_player_stats():
	var path = "user://data/all_player_stats.res"
	
	if !FileAccess.file_exists(path):
		DirAccess.make_dir_recursive_absolute("user://data/")
		var all_player_stats = AllPlayerStats.new()
		ResourceSaver.save(all_player_stats, path)
		
