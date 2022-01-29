extends Node2D

const SPARK := preload("res://Spark/Spark.tscn")
const NUM_SPARKS := 3


func _ready():
	for i in NUM_SPARKS:
		var percent_along = float(i)/NUM_SPARKS
		
		var left = SPARK.instance()
		$LeftSparkPath.add_child(left)
		left.unit_offset = percent_along
		
		var right = SPARK.instance()
		$RightSparkPath.add_child(right)
		right.unit_offset = percent_along
		


func _on_Player1_death():
	print("PLAYER 2 WINS")


func _on_Player2_death():
	print("PLAYER 1 WINS")
