extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	WaveManager.change_cycle.connect(anim)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func anim():
	if WaveManager.phase == WaveManager.Phase.NIGHT:
		$AnimationPlayer.play("fade_in")
	else:
		$AnimationPlayer.play("fade_out")
