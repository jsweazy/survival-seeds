extends CharacterBody2D

const SPEED = 3000.0

var body_texture = preload("res://art/cozy-assets/characters/char1.png")
var shirt_texture = preload("res://art/cozy-assets/clothes/basic.png")
var pants_texture = preload("res://art/cozy-assets/clothes/pants.png")
var shoes_texture = preload("res://art/cozy-assets/clothes/shoes.png")
var hair_texture = preload("res://art/cozy-assets/hair/gentleman.png")

func _ready():
	%Body.texture = body_texture
	%Shirt.texture = shirt_texture
	%Pants.texture = pants_texture
	%Shoes.texture = shoes_texture
	%Hair.texture = hair_texture

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED * delta
	
	move_and_slide()
	
	if velocity.length() > 0.0:
		set_walking(true)
		update_blend_position(velocity.normalized())
	else: 
		set_walking(false)

func set_walking(value):
	%AnimationTree.set("parameters/conditions/is_walking", value)
	%AnimationTree.set("parameters/conditions/idle", not value)
	
func update_blend_position(direction):
	%AnimationTree.set("parameters/idle/blend_position", direction)
	%AnimationTree.set("parameters/walk/blend_position", direction)
