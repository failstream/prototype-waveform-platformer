## mouse.gd

class_name Mouse
extends BaseCharacter


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
  
  var current_x_input: int = get_x_input()
  if current_x_input > 0:
    animated_sprite_2d.set_flip_h(true)
  elif current_x_input < 0:
    animated_sprite_2d.set_flip_h(false)
  velocity.x = velocity_x_calc(current_x_input, delta)
  if _is_player_controlled and Input.is_action_just_pressed("ui_accept") and is_on_floor():
    jump()
  add_gravity_velocity(delta)
  if not is_zero_approx(velocity.x) and is_on_floor():
    animated_sprite_2d.play(&"walking")
  elif is_on_floor():
    animated_sprite_2d.play(&"default")
  elif velocity.y < 0.0:
    animated_sprite_2d.play(&"rising")
  else:
    animated_sprite_2d.play(&"falling")
  move_and_slide()
