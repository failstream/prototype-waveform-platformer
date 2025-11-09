## mouse.gd

class_name Mouse
extends BaseCharacter


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var glow_modulate: Color = Color(1.18, 1.18, 1.18)

func _physics_process(delta: float) -> void:
  
  if Input.is_action_just_pressed("toggle_wave_field"):
    toggle_wave_pressed()
  
  if Input.is_action_just_pressed("swap_character"):
    swap_character_pressed()
  
  if _is_player_controlled:
    modulate = glow_modulate
  else:
    modulate = Color("WHITE")
  
  var current_x_input: int = get_x_input()
  if current_x_input > 0:
    animated_sprite_2d.set_flip_h(true)
  elif current_x_input < 0:
    animated_sprite_2d.set_flip_h(false)
  velocity.x = velocity_x_calc(current_x_input, delta)
  if Input.is_action_just_pressed("jump"):
    jump_input_pressed()
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
