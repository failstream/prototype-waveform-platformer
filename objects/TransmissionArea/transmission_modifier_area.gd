## transmission_modifier_area.gd

class_name TransmissionModifierArea
extends Area2D
## An area that changes the ability of the character that enters it. Can be set to change it back on
## exit or to leave it. What if character overlaps two areas?

## Transmission Possibilities:
  ## ON ENTER
  ## 1) Forces transmission ON
  ## 2) Forces transmission OFF
  ## 
  ## ON EXIT
  ## 1) Leaves transmission FORCED in the position it is in.
  ## 2) Turns transmission off and returns character to default state.
  ## 3) Turns transmission off and returns character to previous state.

## Receiving Possibilities:
  ## ON ENTER
  ## 1) Forces receiving ON
  ## 2) Forces receiving OFF
  ##
  ## ON EXIT
  ## 1) Leaves receiving FORCED in the position it is in.
  ## 2) Returns to the character default state.
  ## 3) Returns to the character's previous state.

## Switching Possibilities:
  ## ON ENTER (player controlled)
  ## 1) Disallows character switching
  ## 2) Allows character switching
  ##
  ## ON EXIT (player controlled)
  ## 1) Returns to default state
  ## 2) Returns to previous state

enum Type { FORCE_ON, FORCE_OFF, NO_CHANGE }

@export var affects_transmission: Type = Type.NO_CHANGE
@export var affects_receiving: Type = Type.NO_CHANGE
@export var affects_switching: Type = Type.NO_CHANGE


var previous_values: Dictionary[BaseCharacter, Dictionary] = {}


func _ready() -> void:
  
  connect(&"area_entered", _area_entered)
  connect(&"area_exited", _area_exited)


func _area_entered(area: Area2D) -> void:
  
  if area.get_parent() is BaseCharacter:
    _character_entered(area.get_parent())


func _area_exited(area: Area2D) -> void:
  
   if area.get_parent() is BaseCharacter:
    pass


func _character_entered(character: BaseCharacter) -> void:
  
  assert(not previous_values.has(character))
  match affects_transmission:
    Type.FORCE_ON:
      character.set_transmission_toggle_capability(false)
      character.set_transmission_status(true)
    Type.FORCE_OFF:
      character.set_transmission_toggle_capability(false)
      character.set_transmission_status(true)
  match affects_receiving:
    Type.FORCE_ON:
      character.set_receiving_status(true)
    Type.FORCE_OFF:
      character.set_receiving_status(false)
