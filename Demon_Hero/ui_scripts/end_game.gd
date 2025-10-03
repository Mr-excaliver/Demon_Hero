extends Control


func _ready():
	$Label.text = "YOUR SCORE:\n" + str(ScoreManager.score)

func _on_submit_button_down():
	var name = $LineEdit.text
	ScoreManager.score_list.append({"name" : name , "score" : ScoreManager.score})
	ScoreManager.score_list_updated()
	ScoreManager.reset()
	get_tree().change_scene_to_file("")
