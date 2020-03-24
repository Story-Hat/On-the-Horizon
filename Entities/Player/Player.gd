extends KinematicBody2D

signal player_stats_changed

var health = 100
var health_max = 100
var health_regen = 1
var stamina = 100
var stamina_max = 100
var stamina_regen = .5
export var speed = 175
var last_direction = Vector2(0, 1)
var dir : Vector2
var attack_playing = false
var inventory_maxSlots = 9

func _ready():
	emit_signal("player_stats_changed", self)
	
func _process(delta):
	#Regenerates stamina
	var new_stamina = min(stamina + stamina_regen * delta, stamina_max)
	if new_stamina != stamina:
		stamina = new_stamina
		emit_signal("player_stats_changed", self)
		
	#Regenerates health
	var new_health = min(health + health_regen * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)

func _physics_process(delta):
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if abs(dir.x) == 1 and abs(dir.y) == 1:
		dir = dir.normalized()
		
	var movement = speed * dir * delta
	move_and_collide(movement)
	if not attack_playing:
		animates_player(dir)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	var pos = get_global_mouse_position() - global_position
	#pos.x = pos.x - 70
	#pos.y = pos.y - 70
	if dir == Vector2.ZERO:
		if pos.x <= -45 and pos.y >= 45:
			return "downleft"
		elif pos.x >= 45 and pos.y >= 45:
			return "downright"
		elif pos.x >= 45 and pos.y <= -45:
			return "upright"
		elif pos.x <= -45 and pos.y <= -45:
			return "upleft"
		elif pos.y > 0 and pos.x >= -45 and pos.x <= 45:
			return "down"
		elif pos.x > 0 and pos.y <= 45 and pos.y >= -45:
			return "right"
		elif pos.y < 0 and pos.x <= 45 and pos.x >= -45:
			return "up"
		elif pos.x < 0 and pos.y >= -45 and pos.y <= 45:
			return "left"
		return "down"
	else:
		if norm_direction.y >= 0.707 and norm_direction.x <= -0.707:
			return "downleft"
		elif norm_direction.y >= 0.707 and norm_direction.x >= 0.707:
			return "downright"
		elif norm_direction.y <= -0.707 and norm_direction.x <= -0.707:
			return "upleft"
		elif norm_direction.y <= -0.707 and norm_direction.x >= 0.707:
			return "upright"
		elif norm_direction.y >= 0.707:
			return "down"
		elif norm_direction.y <= -0.707:
			return "up"
		elif norm_direction.x <= -0.707:
			return "left"
		elif norm_direction.x >= 0.707:
			return "right"
		return "down"
	return "down"
	
func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
		#Changing to _walk once walking anims complete
		var animation = get_animation_direction(last_direction) + "_idle"
		$Sprite.play(animation)
	else:
		var animation = get_animation_direction(last_direction) + "_idle"
		$Sprite.play(animation)

func _input(event): 
	if event.is_action_pressed("attack"):
		attack_playing = true
		var animation = get_animation_direction(last_direction) + "_attack"
		$Sprite.play(animation)
	elif event.is_action_pressed("shoot"):
		attack_playing = true
		var animation = get_animation_direction(last_direction) + "_shoot"
		$Sprite.play(animation)



func _on_Sprite_animation_finished():
	attack_playing = false
