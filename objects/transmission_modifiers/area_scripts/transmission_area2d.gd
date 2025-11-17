## transmission_area2d.gd

class_name TransmissionArea2D
extends CharacterAffectingArea2D

enum Action { ON, OFF }
enum ExitAction { LEAVE, DEFAULT, PREVIOUS }

## This is the effect that the area has, either permanently turns on the transmission, or off
@export var effect: Action

## This is what happens when the character exits the area, changes it back to default value,
## previous value, or leaves it as is.
@export var on_exit: ExitAction

var previous_toggle_value: Dictionary[BaseCharacter, bool] = {}

func character_entered(character: BaseCharacter) -> void:
  super.character_entered(character)
  previous_toggle_value[character] = character._can_toggle_sending
  if effect == Action.ON:
    character.set_transmission_toggle_capability(false)
    character.set_transmission_status(true)
  else:
    character.set_transmission_toggle_capability(false)
    character.set_transmission_status(false)


func character_exited(character: BaseCharacter) -> void:
  super.character_exited(character)
  if on_exit == ExitAction.LEAVE:
    pass # do nothing
  elif on_exit == ExitAction.DEFAULT:
    character.set_transmission_toggle_capability(character.can_toggle_sending)
  elif on_exit == ExitAction.PREVIOUS:
    character.set_transmission_toggle_capability(previous_toggle_value[character])
  previous_toggle_value.erase(character)
