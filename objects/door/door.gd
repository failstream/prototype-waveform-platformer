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

var overlapping_characters: Array[BaseCharacter] = []


func exit_condition_satisfied() -> bool:
  
  for character in overlapping_characters:
    if door_type == DOOR_TYPE.ANY:
      return true
    elif character is Frog and door_type == DOOR_TYPE.GREEN:
      return true
    elif character is Mouse and door_type == DOOR_TYPE.GREY:
      return true
  return false


func _ready() -> void:
  closed_door.set_visible(locked)
  door_area.connect(&"area_entered", _area_entered, CONNECT_PERSIST)
  door_area.connect(&"area_exited", _area_exited, CONNECT_PERSIST)
  set_modulate(door_colors[door_type])
  LevelManager.current_level_root.exits.append(self)


func _area_entered(_area: Area2D) -> void:
  if _area.get_parent() is BaseCharacter:
    if not overlapping_characters.has(_area.get_parent()):
      overlapping_characters.append(_area.get_parent())
      LevelManager.current_level_root.check_level_beaten()

func _area_exited(_area: Area2D) -> void:
  if _area.get_parent() is BaseCharacter:
    if overlapping_characters.has(_area.get_parent()):
      overlapping_characters.remove_at(overlapping_characters.find(_area.get_parent()))
