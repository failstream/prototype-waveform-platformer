extends Node2D


@export var pixel_height: float = 320

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var low_spring_region: Rect2 = Rect2(640, 448, 64, 64)
var high_spring_region: Rect2 = Rect2(640, 384, 64, 64)



func _on_area_2d_spring_character(character: BaseCharacter) -> void:
  character.jump(false, character.calculate_jump_velocity(pixel_height))
  if timer.is_stopped():
    sprite_2d.region_rect = high_spring_region
    timer.start()
  else:
    sprite_2d.region_rect = low_spring_region
    timer.start()
    sprite_2d.call_deferred("set_region_rect", high_spring_region)



func _on_timer_timeout() -> void:
  sprite_2d.region_rect = low_spring_region
