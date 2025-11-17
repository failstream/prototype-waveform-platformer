
@tool
extends AnimatableBody2D


@export var teleport: bool = true
@export var init_time_to_move: float = 1.0
@export var secondary_time_to_move: float = 1.0

@export var initial_position: Marker2D
@export var secondary_position: Marker2D


var _moving: bool = false
var _moving_time: float
var _to_location: Marker2D


func _ready() -> void:
  if Engine.is_editor_hint():
    return
  set_global_position(initial_position.global_position)
  _moving_time = init_time_to_move


func _physics_process(delta: float) -> void:
  if Engine.is_editor_hint():
    return
  if _moving and _to_location != null and not global_position.is_equal_approx(_to_location.global_position):
    set_global_position(global_position.move_toward(_to_location.global_position, delta / _moving_time))


func _move_to_secondary_position() -> void:
  if Engine.is_editor_hint():
    return
  if teleport:
    set_global_position(secondary_position.global_position)
    return
  


func _move_to_initial_position() -> void:
  if Engine.is_editor_hint():
    return
  if teleport:
    set_global_position(initial_position.global_position)
    return
