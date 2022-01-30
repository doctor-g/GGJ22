extends CPUParticles2D

var sound : AudioStream

func _ready():
	assert(sound!=null, "Sound must be specified")
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()
