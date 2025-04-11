extends Node
@export var mob_scene: PackedScene
var score
var lives
@export var food_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$FoodTimer.stop()
	$HUD.show_game_over()

func new_game():
	$Music.play()
	score = 0
	lives = 0
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("food","queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	#$HUD.update_score(score)
	pass
	
func on_hit_mob_handler() -> void:
	if lives == 0:
		game_over()
	else:
		lives -=1

func on_game_increment_score_handler() -> void:
	score += 1
	if score % 5 == 0:
		lives +=1
	$HUD.update_lives(lives)
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$FoodTimer.start()
	$ScoreTimer.start()


func _on_food_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var food = food_scene.instantiate()

	# Choose a random location on Path2D.
	var food_spawn_location = $FoodPath/FoodSpawnLocation
	food_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	food.position = food_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = food_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	food.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	food.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(food)
