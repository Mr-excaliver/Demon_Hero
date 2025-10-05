extends Control


@onready var container = $VBoxContainer
var topscore
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in container.get_children():
		i.queue_free()
	topscore = ScoreManager.score_list.slice(0 ,10)
	for i in range(topscore.size()):
		var cur_ptr = topscore[i]
		var label = Label.new()
		label.text = str(i+1) + " " + cur_ptr["name"]+ " " + str(cur_ptr["score"])
		label.add_theme_font_size_override("font_size", 30)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		container.add_child(label)
		
	


func _process(delta):
	pass


func _on_main_menu_button_down():
	get_tree().change_scene_to_file("res://ui_scenes/main_menu.tscn")
