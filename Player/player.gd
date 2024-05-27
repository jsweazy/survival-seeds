extends CharacterBody2D

const SPEED = 80.0

var body_texture = preload("res://art/cozy-assets/characters/char1.png")
var shirt_texture = preload("res://art/cozy-assets/clothes/basic.png")
var pants_texture = preload("res://art/cozy-assets/clothes/pants.png")
var shoes_texture = preload("res://art/cozy-assets/clothes/shoes.png")
var hair_texture = preload("res://art/cozy-assets/hair/gentleman.png")

@onready var body = %Body
@onready var shirt = %Shirt
@onready var pants = %Pants
@onready var shoes = %Shoes
@onready var hair = %Hair
@onready var animation_tree = %AnimationTree

var is_tilling = false
var is_harvesting = false

func _ready():
	body = body_texture
	shirt = shirt_texture
	pants = pants_texture
	shoes = shoes_texture
	hair = hair_texture
	animation_tree.active = true
	
func _process(_delta):
	update_animation()

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if !is_tilling and !is_harvesting:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func update_animation():
	if velocity.length() > 0.0 and !is_tilling and !is_harvesting:
		set_walking(true)
		update_blend_position(velocity)
	else: 
		set_walking(false)
		
func set_walking(value):
	animation_tree.set("parameters/conditions/is_walking", value)
	animation_tree.set("parameters/conditions/idle", not value)
	
func update_blend_position(direction):
	animation_tree.set("parameters/till/blend_position", direction)
	animation_tree.set("parameters/idle/blend_position", direction)
	animation_tree.set("parameters/walk/blend_position", direction)
	animation_tree.set("parameters/mine/blend_position", direction)

func set_tilling(value = false):
	is_tilling = value
	animation_tree.set("parameters/conditions/is_tilling", value)
	
func set_mining(value = false):
	is_harvesting = value
	animation_tree.set("parameters/conditions/is_mining", value)
