extends Control

@onready var Bar = $TextureProgressBar
@onready var mag = $mag
@onready var score = $score
@onready var WAVE = $WAVE

# Called when the node enters the scene tree for the first time.
func _ready():
	Bar.max_value = PlayerStat.health
	Bar.value = PlayerStat.health
	score.text = "SCORE:\n" + str(ScoreManager.score)
	PlayerStat.health_change.connect(health_update)
	PlayerStat.took_damage.connect(health_value)
	ScoreManager.score_update.connect(score_update)
	PlayerStat.mag_amt.connect(mag_update)
	WaveManager.wave_no.connect(wave_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func health_update(health):
	Bar.max_value = health
	

func health_value(health):
	Bar.value = health
	

func score_update():
	score.text = "SCORE:\n" + str(ScoreManager.score)
	
func mag_update(new_mag):
	mag.text = str(new_mag)

func wave_update():
	WAVE.text = "WAVE " + str(WaveManager.wave)
	WAVE.visible = true
	$wave_timer.start()

func _on_wave_timer_timeout():
	WAVE.visible = false
