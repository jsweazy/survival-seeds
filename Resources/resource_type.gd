extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

@export var type = 'choppable'

func _ready():
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func harvest():
	animated_sprite_2d.play("default")
	pass

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.set_frame_and_progress(0, 0.0)
