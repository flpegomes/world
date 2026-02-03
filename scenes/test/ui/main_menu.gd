extends Control

@export var menu: VBoxContainer
@export var main_settings: VBoxContainer
@export var video_settings: VBoxContainer
@export var audio_settings: VBoxContainer
@export var controls_settings: VBoxContainer
@export var game_settings: VBoxContainer

@export var video_button: Button
@export var audio_button: Button
@export var controls_button: Button
@export var game_button: Button  
@export var settings_button: Button


var nav_stack: Array[Control] = []
var current_panel

func _ready():
	current_panel = menu
	_show_panel(menu)
	
	settings_button.pressed.connect(_navigate_to.bind(main_settings))
	video_button.pressed.connect(_navigate_to.bind(video_settings))
	audio_button.pressed.connect(_navigate_to.bind(audio_settings))
	controls_button.pressed.connect(_navigate_to.bind(controls_settings))
	game_button.pressed.connect(_navigate_to.bind(game_settings))

func _show_panel(panel: Control): 
	panel.visible = true

func _navigate_to(panel: Control): 
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false
	
	current_panel = panel
	_show_panel(current_panel)
