extends Node2D

const SPARK := preload("res://Spark/Spark.tscn")
const NUM_SPARKS := 3
const RIGHT_SPARK_UNIT_OFFSET := 1/(NUM_SPARKS*2.0)
const ENEMY := preload("res://Enemy/Enemy.tscn")
const END_GAME_DELAY := 3.0

onready var _enemies := $Enemies
onready var _player1 := $LeftZone/Player1
onready var _player2 := $RightZone/Player2

func _ready():
	Globals.playing = true
	for i in NUM_SPARKS:
		var percent_along = float(i)/NUM_SPARKS
		
		var left = SPARK.instance()
		$LeftSparkPath.add_child(left)
		left.unit_offset = percent_along
		left.connect("hit", self, "_on_Spark_hit", [left])
		
		var right = SPARK.instance()
		$RightSparkPath.add_child(right)
		right.unit_offset = percent_along + RIGHT_SPARK_UNIT_OFFSET
		right.connect("hit", self, "_on_Spark_hit", [right])


func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		$PauseMenu.show_modal(true)


func _on_Player1_death():
	print("PLAYER 2 WINS")
	_player2.show_halo()
	_end_game()


func _on_Player2_death():
	print("PLAYER 1 WINS")
	_player1.show_halo()
	Globals.playing = false
	_end_game()
	

func _end_game():
	Globals.playing = false
	yield(get_tree().create_timer(END_GAME_DELAY), "timeout")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_Spark_hit(player_index:int, spark:Node2D)->void:
	call_deferred("_spawn_enemy", spark, player_index==0)


func _spawn_enemy(spark:Node2D, left:bool)->void:
	var enemy = ENEMY.instance()
	_enemies.add_child(enemy)
	enemy.global_position = spark.global_position
	var viewport_width = get_viewport_rect().size.x
	enemy.position.x += (viewport_width/2 if left else -viewport_width/2)
	enemy.target = _player2 if left else _player1
