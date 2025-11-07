## door.gd

class_name Door
extends Node2D


@export var locked: bool = false


@onready var closed_door: Sprite2D = $ClosedDoor
@onready var door_area: Area2D = $DoorArea

enum DOOR_TYPE { ANY, GREEN, GREY }
@export var door_type: DOOR_TYPE
@export var door_colors: Dictionary[DOOR_TYPE, Color] = {
  
}



func _ready() -> void:
  closed_door.set_visible(locked)
  door_area.connect(&"area_entered", _area_entered, CONNECT_PERSIST)
  door_area.connect(&"area_exited", _area_exited, CONNECT_PERSIST)
  set_modulate(door_colors[door_type])


func _area_entered(_area: Area2D) -> void:
  if door_type == DOOR_TYPE.GREEN and _area.get_parent() is Frog:
    print("hello frog")
  elif door_type == DOOR_TYPE.GREY and _area.get_parent() is Mouse:
    print("hello mouse")
  elif door_type == DOOR_TYPE.ANY and _area.get_parent() is BaseCharacter:
    print("hello anyone")
  ## check area parent if it is correct character
  ## check all doors if correct character is on them
  ## BING


func _area_exited(_area: Area2D) -> void:
  print("goodbye")
