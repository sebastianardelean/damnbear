extends Area2D

signal hit_mob

signal hit_food

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "right"
	elif velocity.x < 0:		
		$AnimatedSprite2D.animation = "left"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "down"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		hit_mob.emit()
	elif body.is_in_group("food"):
		hit_food.emit()
		
	
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
