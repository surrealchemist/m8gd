extends M8Scene

@onready var camera: HumanizedCamera3D = %Camera3D

@export var enable_mouse_controlled_pan_zoom := true:
	set(value):
		%Camera3D.mouse_controlled_pan_zoom = value
		enable_mouse_controlled_pan_zoom = value

@export var humanized_camera_movement := true:
	set(value):
		%Camera3D.humanized_movement = value
		humanized_camera_movement = value

@export var enable_depth_of_field := true:
	set(value):
		%Camera3D.attributes.dof_blur_far_enabled = value
		%Camera3D.attributes.dof_blur_near_enabled = value
		enable_depth_of_field = value

@export var model_screen_emission := 0.25:
	set(value):
		if %DeviceModel is DeviceModel:
			var screen: MeshInstance3D = %DeviceModel.get_node("%Screen")
			screen.material_override.set_shader_parameter("emission_amount", value)
		model_screen_emission = value

@export var surface_color := Color(0.0, 0.0, 0.0):
	set(value):
		surface_color = value
		%SurfaceMesh.material_override.albedo_color = value

@export var enable_directional_light := true:
	set(value):
		enable_directional_light = value
		%DirectionalLight3D.visible = value

@export var directional_light_color := Color(0.9, 0.9, 1.0, 0.25):
	set(value):
		left_light_color = value
		%DirectionalLight3D.light_color = value
		%DirectionalLight3D.light_energy = value.a * 4
	
@export var enable_lamp_light := true:
	set(value):
		enable_lamp_light = value
		%LightLamp.visible = value

@export var lamp_light_color := Color(1, 0.9, 0.6):
	set(value):
		left_light_color = value
		%LightLamp.light_color = value
		%LightLamp.light_energy = value.a

@export var enable_left_light := false:
	set(value):
		enable_left_light = value
		%LightLeft.visible = value

@export var left_light_color := Color(1, 0, 0):
	set(value):
		left_light_color = value
		%LightLeft.light_color = value
		%LightLeft.light_energy = value.a * 16

@export var enable_right_light := false:
	set(value):
		enable_right_light = value
		%LightRight.visible = value

@export var right_light_color := Color(0, 0, 1):
	set(value):
		right_light_color = value
		%LightRight.light_color = value
		%LightRight.light_energy = value.a * 16

func init(p_main: M8SceneDisplay) -> void:
	super(p_main)

	%DeviceModel.init(main)

func _physics_process(delta: float) -> void:

	if main.is_menu_open(): return

	camera.update(delta)