extends CharacterBody2D
signal died
var state = State.MOVE
var MAX_SPEED = PlayerStat.speed
const ACCELERATION = 30
const JUMP_VELOCITY = -400.0
var motion = Vector2()
var max_health = PlayerStat.health
var current_health
var dash_dir = 0 
var dash_strength = 1700
var is_dashing = false
var can_dash  = true
@onready var dashtimer = $dashtimer
var knockback_receiver = true
var knockback_magnitude = 0.1
@onready var hurtbox = $hurtbox/CollisionShape2D
@onready var cooldown = $cooldown
@onready var invinc = $invinc
enum State{
	MOVE,
	HIT
}
func _ready():
	add_to_group("player")
	current_health = max_health
	PlayerStat.health_change.connect(health_update)
	PlayerStat.speed_change.connect(speed_update)
	self.died.connect(WaveManager.player_died)
	

func _physics_process(_delta):

	match state:
		State.MOVE:
			movement()
		State.HIT:
			hit()
	set_velocity(motion)
	move_and_slide()
	motion = velocity

func hit():
	current_health -= EnemyStat.enemy_damage
	if current_health <= 0:
		PlayerStat.died_count +=1
		emit_signal("died")
		queue_free()
	state = State.MOVE


func movement():


	if Input.is_action_pressed("right") :
		motion.x = min(MAX_SPEED, motion.x + ACCELERATION)


	elif Input.is_action_pressed("left"):
		motion.x = max(-MAX_SPEED, motion.x - ACCELERATION)


	else:
		motion.x = lerp(motion.x,0.0,0.2)
	if Input.is_action_pressed("down") :
		motion.y = min(MAX_SPEED, motion.y + ACCELERATION)


	elif Input.is_action_pressed("up"):
		motion.y = max(-MAX_SPEED, motion.y - ACCELERATION)


	else:
		motion.y = lerp(motion.y,0.0,0.2)
	
	if Input.is_action_just_pressed("dash") && can_dash == true:
		can_dash = false
		dashtimer.start()
		is_dashing= true
		dash_dir = motion.normalized()
		motion.x = motion.x + dash_strength * dash_dir.x
		motion.y = motion.y + dash_strength * dash_dir.y
	elif Input.is_action_just_released("dash"):
		is_dashing = false
	
	move_and_slide()


func health_update(new_health):
	max_health = new_health

func speed_update(new_speed):
	MAX_SPEED = new_speed


func _on_gun_shooting(gun_knockback):
	if knockback_receiver== true:
		var knockback_dir = get_global_mouse_position().direction_to(self.global_position)
		var knockback_strength = knockback_magnitude * gun_knockback
		var knockback =knockback_dir * knockback_strength
		global_position += knockback




func _on_dashtimer_timeout():
	can_dash = true





func _on_hurtbox_area_entered(area):
	if area.name == "e_hitbox":
		hurtbox.disabled = true
		invinc.start()
		var knockback_dir = (self.global_position - area.global_position).normalized()
		var knockback_strength = knockback_magnitude * 1000
		var knockback = knockback_dir * knockback_strength
		global_position+= knockback
		state = State.HIT
		


func _on_invinc_timeout():
	hurtbox.disabled = false
