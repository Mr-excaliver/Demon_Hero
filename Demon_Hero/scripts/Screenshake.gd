extends Node2D


var current_shake_priority = 0 


func _ready():
	WaveManager.shake.connect(screen_shake)

func move_camera(vector):
	var play = get_tree().get_first_node_in_group("player")
	var Camera
	if play:
		Camera = play.get_node("Camera2D")
	else:
		Camera = get_parent().get_node("Camera2D")
	if Camera:
		Camera.offset = Vector2(randf_range(-vector.x,vector.x), randf_range(-vector.y , vector.y))

func screen_shake(shake_length, shake_power, shake_priority):
	if shake_priority > current_shake_priority:
		current_shake_priority = shake_priority
		create_tween().tween_method(move_camera, Vector2(shake_power, shake_power) , Vector2(0,0) , shake_length)
		create_tween().tween_callback(tween_reset).set_delay(shake_length)
 


func tween_reset():
	current_shake_priority = 0
	
