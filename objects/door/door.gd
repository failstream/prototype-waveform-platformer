## door.gd

class_name Door
extends Node2D


@export var locked: bool = false


@onready var closed_door: Sprite2D = $ClosedDoor
@onready var door_area: Area2D = $DoorArea

enum DOOR_TYPE { ANY, BLUE, YELLOW }


func _ready() -> void:
  closed_door.set_visible(locked)
  door_area.connect(&"area_entered", _area_entered, CONNECT_PERSIST)
  door_area.connect(&"area_exited", _area_exited, CONNECT_PERSIST)



func _area_entered(_area: Area2D) -> void:
  print("hello")
  ## check area parent if it is correct character
  ## check all doors if correct character is on them
  ## BING


func _area_exited(_area: Area2D) -> void:
  print("goodbye")
