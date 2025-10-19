extends VBoxContainer


@onready var display_mask_up: PanelContainer = $HBoxContainer/DisplayMaskUp
@onready var display_mask_left: PanelContainer = $HBoxContainer2/DisplayMaskLeft
@onready var display_mask_right: PanelContainer = $HBoxContainer2/DisplayMaskRight
@onready var display_mask_down: PanelContainer = $HBoxContainer3/DisplayMaskDown


func _ready() -> void:
	Globals.mask_collected.connect(_mask_collected)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mask_up") and display_mask_up.enabled:
		_switch_mask(0)
	
	if event.is_action_pressed("mask_left") and display_mask_left.enabled:
		_switch_mask(1)
	
	if event.is_action_pressed("mask_right") and display_mask_right.enabled:
		_switch_mask(2)
	
	if event.is_action_pressed("mask_down") and display_mask_down.enabled:
		_switch_mask(3)


func _switch_mask(n: int) -> void:
	if n == Globals.current_mask:
		return
	
	Globals.current_mask = n
	
	match n:
		0:
			if display_mask_up.enabled == false:
				return
			display_mask_up.selected = true
			display_mask_left.selected = false
			display_mask_right.selected = false
			display_mask_down.selected = false
		1:
			if display_mask_left.enabled == false:
				return
			display_mask_up.selected = false
			display_mask_left.selected = true
			display_mask_right.selected = false
			display_mask_down.selected = false
		2:
			if display_mask_right.enabled == false:
				return
			display_mask_up.selected = false
			display_mask_left.selected = false
			display_mask_right.selected = true
			display_mask_down.selected = false
		3:
			if display_mask_down.enabled == false:
				return
			display_mask_up.selected = false
			display_mask_left.selected = false
			display_mask_right.selected = false
			display_mask_down.selected = true
	
	Globals.mask_switched.emit()


func _mask_collected(n: int) -> void:
	match n:
		0:
			display_mask_up.enabled = true
			_switch_mask(0)
		1:
			display_mask_left.enabled = true
			_switch_mask(1)
		2:
			display_mask_right.enabled = true
			_switch_mask(2)
		3:
			display_mask_down.enabled = true
			_switch_mask(3)
