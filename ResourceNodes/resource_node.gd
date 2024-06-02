extends StaticBody2D
class_name ResourceNode

enum RESOURCE_TYPE {
	CHOPPABLE,
	MINEABLE
}

@export var animated_sprite_2d: AnimatedSprite2D
@export var type: RESOURCE_TYPE;
@export var health = 3
@export var dropped_item: PackedScene
@export var min_resources: int = 1
@export var max_resources: int = 3

@onready var parent_level = get_parent()

var is_harvesting = false

func _ready():
	animated_sprite_2d.autoplay = ""
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	animated_sprite_2d.animation_looped.connect(_on_animated_sprite_2d_animation_finished)

func harvest():
	if is_harvesting:
		return;
		
	animated_sprite_2d.play("default")
	is_harvesting = true
	health -= 1
	
	if health <= 0:
		spawn_resources()
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.stop()
	animated_sprite_2d.set_frame_and_progress(0, 0.0)
	is_harvesting = false
	
func spawn_resources():
	for n in randi_range(min_resources, max_resources):
		var resource = dropped_item.instantiate() as PickupItem
		parent_level.add_child(resource)
		resource.position = position;
