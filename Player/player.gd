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
@onready var interact_area = %InteractArea
@onready var tile_map: TileMap = get_parent().find_child("TileMap")

var is_tilling = false
var is_harvesting = false
var in_interact_area = false

var direction: Vector2 = Vector2.ZERO
var tile_map_position: Vector2i
var grid_helpers : Array[GridHelper] = []

func _ready():
	body = body_texture
	shirt = shirt_texture
	pants = pants_texture
	shoes = shoes_texture
	hair = hair_texture
	animation_tree.active = true
	tile_map_position = tile_map.local_to_map(global_position) * 16
	
	var grid_helper = preload("res://Scenes/grid_helper.tscn")
	for helper_key in GridHelper.GridHelperPosition.values():
		var helper = grid_helper.instantiate()
		helper.set_helper_position_type(helper_key)
		grid_helpers.append(helper)
		add_child(helper)
	
	interact_area.connect("mouse_entered", _on_interact_area_mouse_entered)
	interact_area.connect("mouse_exited", _on_interact_area_mouse_exited)
	
	print(interact_area.global_position)
	
func _process(_delta):
	update_animation()

func _physics_process(_delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if !is_tilling and !is_harvesting:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	tile_map_position = tile_map.local_to_map(global_position) * 16
	
	## some reason its 8 px off... not sure why
	interact_area.global_position = Vector2i(
		tile_map_position.x + 8,
		tile_map_position.y + 8
	)
	
	for grid_helper in grid_helpers:
		grid_helper.update_position(tile_map_position)

func update_animation():
	if velocity.length() > 0.0 and !is_tilling and !is_harvesting:
		set_walking(true)
		update_blend_position(velocity)
	else: 
		set_walking(false)
		
func set_walking(value):
	animation_tree.set("parameters/conditions/is_walking", value)
	animation_tree.set("parameters/conditions/idle", not value)
	
func update_blend_position(dir):
	animation_tree.set("parameters/till/blend_position", dir)
	animation_tree.set("parameters/idle/blend_position", dir)
	animation_tree.set("parameters/walk/blend_position", dir)
	animation_tree.set("parameters/mine/blend_position", dir)

func set_tilling(value = false, pos: Vector2 = Vector2.ZERO):
	is_tilling = value
	animation_tree.set("parameters/conditions/is_tilling", value)
	
	if (pos != Vector2.ZERO):
		update_blend_position(global_position.direction_to(pos))
	
func set_mining(value = false, pos: Vector2 = Vector2.ZERO):
	is_harvesting = value
	animation_tree.set("parameters/conditions/is_mining", value)
	
	if (pos != Vector2.ZERO):
		update_blend_position(global_position.direction_to(pos))

func _input(_event):
	if Input.is_action_just_pressed("harvest"):
		if not in_interact_area:
			return
		harvest()

func _on_interact_area_mouse_entered():
	in_interact_area = true

func _on_interact_area_mouse_exited():
	in_interact_area = false

func harvest():
	var mouse_position = get_global_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_position
	query.collide_with_areas = true
	var intersections = get_world_2d().direct_space_state.intersect_point(query)
	
	for intersection in intersections:
		if (intersection.collider is HarvestArea):
			# TODO: harvest bases on type
			set_mining(true, intersection.collider.get_parent().global_position)
			return
	
	var tile_mouse_position = tile_map.local_to_map(mouse_position)
	var dirt_tile_atlas_cord = Vector2i(6, 9)
	
	var ground_tile_data: TileData = tile_map.get_cell_tile_data(tile_map.ground_layer, tile_mouse_position)
	
	if ground_tile_data:
		var can_till = ground_tile_data.get_custom_data('can_till')
		
		if can_till:
			tile_map.set_cell(tile_map.ground_layer, tile_mouse_position, tile_map.main_tile_source_id, dirt_tile_atlas_cord)
			set_tilling(true, mouse_position)
		else: 
			print('cant place here')
	else:
		print('no tile data')
