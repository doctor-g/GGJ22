extends Node2D

const SPARK := preload("res://Spark/Spark.tscn")
const NUM_SPARKS := 3
const RIGHT_SPARK_UNIT_OFFSET := 1/(NUM_SPARKS*2.0)
const ENEMY := preload("res://Enemy/Enemy.tscn")

onready var _enemies := $Enemies
onready var _player1 := $LeftZone/Player1
onready var _player2 := $RightZone/Player2

func _ready():
	for i in NUM_SPARKS:
		var percent_along = float(i)/NUM_SPARKS
		
		var left = SPARK.instance()
		$LeftSparkPath.add_child(left)
		left.unit_offset = percent_along
		left.connect("death", self, "_on_Spark_death", [left, true], CONNECT_ONESHOT)
		
		var right = SPARK.instance()
		$RightSparkPath.add_child(right)
		right.unit_offset = percent_along + RIGHT_SPARK_UNIT_OFFSET
		right.connect("death", self, "_on_Spark_death", [right, false], CONNECT_ONESHOT)


func _on_Player1_death():
	print("PLAYER 2 WINS")


func _on_Player2_death():
	print("PLAYER 1 WINS")


func _on_Spark_death(spark:Node2D, left:bool)->void:
	call_deferred("_spawn_enemy", spark,left)


func _spawn_enemy(spark:Node2D, left:bool)->void:
	var enemy = ENEMY.instance()
	_enemies.add_child(enemy)
	enemy.global_position = spark.global_position
	var viewport_width = get_viewport_rect().size.x
	enemy.position.x += (viewport_width/2 if left else -viewport_width/2)
	enemy.target = _player2 if left else _player1
