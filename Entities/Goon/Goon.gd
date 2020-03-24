extends KinematicBody2D


var player

var rng = RandomNumberGenerator.new()

export var speed = 100
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0
var other_anim_playing = false
var entered = 0

func _ready():
	player = get_tree().root.get_node("Root/YSort/Player")
	rng.randomize()


func _on_Timer_timeout():
	# Calculate the position of the player relative to the skeleton
	var player_relative_position = player.position - position
	
	if player_relative_position.length() <= 16:
		# If player is near, don't move but turn toward it
		direction = Vector2.ZERO
		last_direction = player_relative_position.normalized()
	elif player_relative_position.length() <= 500 and bounce_countdown == 0:
		# If player is within range, move toward it
		direction = player_relative_position.normalized()
	elif bounce_countdown == 0:
		# If player is too far, randomly decide whether to stand still or where to move
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < .1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
		
func _physics_process(delta):
	var movement = direction * speed * delta
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
	if not other_anim_playing:
		#set_scale(Vector2(rng.randf_range(.1, 2), rng.randf_range(.1, 2))) 
		animates_goon(direction)
		
func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animates_goon(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
		#TODO
		#var animation = get_animation_direction(last_direction) + "_walk"		
		$AnimatedSprite.play("default")
	else:
		#TODO
		#var animation = get_animation_direction(last_direction) + "_idle"
		$AnimatedSprite.play("default")
		
func arise():
	other_anim_playing = true
	$AnimatedSprite.play("birth")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "birth":
		$AnimatedSprite.animation = "default"
		$Timer.start()
	other_anim_playing = false
