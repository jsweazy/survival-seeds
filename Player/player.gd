extends CharacterBody2D

const SPEED = 3000.0

var body_texture = preload("res://art/cozy-assets/characters/char1.png")
var shirt_texture = preload("res://art/cozy-assets/clothes/basic.png")
var pants_texture = preload("res://art/cozy-assets/clothes/pants.png")
var shoes_texture = preload("res://art/cozy-assets/clothes/shoes.png")
var hair_texture = preload("res://art/cozy-assets/hair/gentleman.png")

var is_tilling = false

func _ready():
	%Body.texture = body_texture
	%Shirt.texture = shirt_texture
	%Pants.texture = pants_texture
	%Shoes.texture = shoes_texture
	%Hair.texture = hair_texture
	%AnimationTree.active = true
	
func _process(delta):
	update_animation()

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if !is_tilling:
		velocity = direction * SPEED * delta
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()	

func update_animation():
	if velocity.length() > 0.0 and !is_tilling:
		set_walking(true)
		update_blend_position(velocity.normalized())
	else: 
		set_walking(false)
		
func set_walking(value):
	%AnimationTree.set("parameters/conditions/is_walking", value)
	%AnimationTree.set("parameters/conditions/idle", not value)
	
func update_blend_position(direction):
	%AnimationTree.set("parameters/till/blend_position", direction)
	%AnimationTree.set("parameters/idle/blend_position", direction)
	%AnimationTree.set("parameters/walk/blend_position", direction)

func _on_game_is_tilling():
	set_tilling(true)

func set_tilling(value = false):
	is_tilling = value
	%AnimationTree.set("parameters/conditions/is_tilling", value)
