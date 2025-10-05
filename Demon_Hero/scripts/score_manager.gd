extends Node

signal score_update

var score = 0

var score_list = []




func score_list_updated():
	score_list.sort_custom(sort_dec)

func reset():
	score = 0


func sort_dec(a,b):
	return b["score"] - a["score"]
	

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
		score_list = parsed_text.result

func score_updated():
	emit_signal("score_update")
