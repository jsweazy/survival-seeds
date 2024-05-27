extends Area2D
class_name GridHelper

@export var border_color: Color = Color(100, 0, 0, 0.7)

@onready var panel = %Panel

enum GridHelperPosition {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT,
	CENTER,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

var _grid_helper_position: GridHelperPosition

var empty_style: StyleBoxFlat
var hover_style: StyleBoxFlat
var helper_key_down = false

func _ready():
	empty_style = panel.get_theme_stylebox("panel").duplicate()
	hover_style = panel.get_theme_stylebox("panel").duplicate()
	
	var transparent = Color(0, 0, 0, 0);
	empty_style.bg_color = transparent
	empty_style.border_color = transparent
	
	hover_style.bg_color = transparent
	hover_style.border_color = border_color
	hover_style.border_width_top = 1
	hover_style.border_width_bottom = 1
	hover_style.border_width_right = 1
	hover_style.border_width_left = 1
	hover_style.corner_radius_top_right = 0
	hover_style.corner_radius_top_left = 0
	hover_style.corner_radius_bottom_right = 0
	hover_style.corner_radius_bottom_left = 0
	
	panel.add_theme_stylebox_override('panel', empty_style)
	panel.hide()	

func _on_panel_mouse_entered():
	if helper_key_down:
		panel.add_theme_stylebox_override('panel', hover_style)

func _on_panel_mouse_exited():
	panel.add_theme_stylebox_override('panel', empty_style)

func update_position(position: Vector2i) -> void:
	var helper_pos = Vector2i(position)
	match _grid_helper_position:
		GridHelperPosition.TOP:
			helper_pos.y -= 16
		GridHelperPosition.BOTTOM:
			helper_pos.y += 16
		GridHelperPosition.LEFT:
			helper_pos.x -= 16
		GridHelperPosition.RIGHT:
			helper_pos.x += 16
		GridHelperPosition.TOP_RIGHT:
			helper_pos.y -= 16
			helper_pos.x += 16
		GridHelperPosition.TOP_LEFT:
			helper_pos.y -= 16
			helper_pos.x -= 16
		GridHelperPosition.BOTTOM_RIGHT:
			helper_pos.y += 16
			helper_pos.x += 16
		GridHelperPosition.BOTTOM_LEFT:
			helper_pos.y += 16
			helper_pos.x -= 16
	
	global_position = helper_pos

func set_helper_position_type(grid_helper_position: GridHelperPosition):
	_grid_helper_position = grid_helper_position

func _process(delta):
	if Input.is_action_just_pressed("grid_helper"):
		panel.show()
		helper_key_down = true
	
	if Input.is_action_just_released("grid_helper"):
		panel.hide()
		helper_key_down = false
		_on_panel_mouse_exited()
