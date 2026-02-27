extends CPUParticles2D

func _ready():
	# Começa a explodir assim que nasce
	emitting = true

func _process(_delta):
	# Se acabou de explodir se mata.
	if not emitting:
		queue_free()
