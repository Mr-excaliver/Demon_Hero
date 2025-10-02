extends CharacterBody2D


signal died
var speed= EnemyStat.enemy_speed

@onready var hitbox = $e_hitbox/CollisionShape2D
@onready var atk_cooldown = $attack

var base_score = 50
var player
var monument
var health = EnemyStat.enemy_health
var state = IDLE
var is_attacking = false
var initial_pos
enum{
	CHASE,
	ATTACK,
	IDLE
}





func _ready():
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")
	initial_pos = self.global_position


func _physics_process(_delta):

	if health<=0:
		ScoreManager.score += base_score * WaveManager.wave
		emit_signal("died")
		queue_free()
	match state:
		CHASE:
			chase()
		ATTACK:
			attack()
		IDLE:
			idle()
	
	move_and_slide()



func chase():

	if not player:
		state = IDLE
	else:
		if (player.global_position - initial_pos).length() < 600 or (player.global_position - self.global_position).length() < 500:
			velocity = speed * (player.global_position - self.global_position).normalized()
		else :
			state = IDLE


func idle():
	if not player:
		if self.global_position != initial_pos:
			self.global_position.x = move_toward(self.global_position.x , initial_pos.x , 5)
			self.global_position.y = move_toward(self.global_position.y , initial_pos.y , 5)
	else:
		if (player.global_position - initial_pos).length() < 600 or (player.global_position - self.global_position).length() < 500:
			state = CHASE
		else:
			if self.global_position != initial_pos:
				self.global_position.x = move_toward(self.global_position.x , initial_pos.x , 5)
				self.global_position.y = move_toward(self.global_position.y , initial_pos.y , 5)




func attack():
	velocity = Vector2.ZERO
	if not is_attacking:
		is_attacking = true
		hitbox.disabled = false
		atk_cooldown.start()



func _on_attack_timeout():
	hitbox.disabled = true
	is_attacking = false

func _on_hurtbox_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
		health -=PlayerStat.damage


func _on_detector_area_entered(_area):
	state = ATTACK


func _on_detector_area_exited(area):
	if area.name == "mhurtbox":
		state = IDLE
	state = CHASE
