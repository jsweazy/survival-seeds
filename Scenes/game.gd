extends Node2D

const ground_layer = 0
const enviorment_layer = 1

const main_tile_source_id = 0

signal is_tilling

func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("harvest"):
		var mouse_position = get_global_mouse_position()
		var tile_mouse_position = %TileMap.local_to_map(mouse_position)
		var dirt_tile_atlas_cord = Vector2i(6, 9)
		
		var ground_tile_data : TileData = %TileMap.get_cell_tile_data(ground_layer, tile_mouse_position)
		var env_tile_data: TileData = %TileMap.get_cell_tile_data(enviorment_layer, tile_mouse_position)
		
		if ground_tile_data:
			var can_till = ground_tile_data.get_custom_data('can_till')
			
			# TODO: figure out tilling around trees. since they go outside single tile
			if !env_tile_data and can_till:
				is_tilling.emit()
				%TileMap.set_cell(ground_layer, tile_mouse_position, main_tile_source_id, dirt_tile_atlas_cord)
			else: 
				print('cant place here')
		else:
			print('no tile data')
