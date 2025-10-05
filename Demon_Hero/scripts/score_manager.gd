extends Node

signal score_update

var score = 0

var score_list = []

func _ready():
	load_list()
	score_list_updated()
	print(score_list)

func reset():
	score = 0

func score_list_updated():
	score_list.sort_custom(Callable(self,"sort_dec"))



func sort_dec(a,b):
	return a["score"] > b["score"]
	

func save_list():
	var path = "res://score/score.json"
	var file = FileAccess.open(path , FileAccess.WRITE)
	if file:
		var json_text = JSON.stringify(score_list)
		file.store_string(json_text)
		file.close()


func load_list():
	var path = "res://score/score.json"
	var file = FileAccess.open(path , FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var parsed_text = JSON.parse_string(json_text)
		if parsed_text:
			score_list = parsed_text

func score_updated():
	emit_signal("score_update")
