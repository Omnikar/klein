@tool
class_name Switch extends Interactable

signal switch_turned_on
signal switch_turned_off
signal switch_updated(state: bool)

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if $Background:
			$Background.modulate = color

## Whether the switch is on or off
@export var state: bool = false:
	get():
		return state
	set(value):
		var old = state
		state = value
		if old != state:
			send_switch_signals()
		$AnimationPlayer.play("on" if state else "off")


func interact() -> void:
	state = !state


func send_switch_signals() -> void:
	switch_updated.emit(state)
	if state:
		switch_turned_on.emit()
		$ClickSound.pitch_scale = 1.0
		$ClickSound.play()
	else:
		switch_turned_off.emit()
		$ClickSound.pitch_scale = 0.7
		$ClickSound.play()
