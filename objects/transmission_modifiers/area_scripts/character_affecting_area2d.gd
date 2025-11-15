## character_affecting_area2d.gd

@abstract
class_name CharacterAffectingArea2D
extends Area2D
## An Area2D class that tracks BaseCharacters that enter it. Keeps an array of BaseCharacters to track
## what characters are already in the area.

var overlapping_characters: Array[BaseCharacter] = []

func _ready() -> void:
  
  connect(&"area_entered", _area_entered)
  connect(&"area_exited", _area_exited)


func tracks_character_type(_character: BaseCharacter) -> bool:
  return true

func character_present(character: BaseCharacter) -> bool:
  if overlapping_characters.has(character):
    return true
  return false


func _area_entered(area: Area2D) -> void:
  
  var area_parent: Node = area.get_parent()
  if area_parent is BaseCharacter and tracks_character_type(area_parent) and not overlapping_characters.has(area_parent):
    character_entered(area_parent)


func _area_exited(area: Area2D) -> void:
  
  var area_parent: Node = area.get_parent()
  if area_parent is BaseCharacter and overlapping_characters.has(area_parent):
    character_exited(area_parent)


func character_entered(character: BaseCharacter) -> void:
  overlapping_characters.append(character)


func character_exited(character: BaseCharacter) -> void:
  overlapping_characters.remove_at(overlapping_characters.find(character))
