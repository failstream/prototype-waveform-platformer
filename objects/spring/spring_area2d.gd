## spring_area2d.gd


extends CharacterAffectingArea2D

signal spring_character

func character_entered(character: BaseCharacter) -> void:
  super.character_entered(character)
  spring_character.emit(character)
