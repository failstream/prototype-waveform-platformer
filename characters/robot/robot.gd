## robot.gd


class_name Robot
extends BaseCharacter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var head: Sprite2D = $Graphics/Head
@onready var body: Sprite2D = $Graphics/Body
@onready var wheel: Sprite2D = $Graphics/Wheel

var glow_modulate: Color = Color(1.269, 1.269, 1.269)

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
    head.set_flip_h(false)
    body.set_flip_h(false)
    wheel.set_flip_h(false)
  elif current_x_input < 0:
    head.set_flip_h(true)
    body.set_flip_h(true)
    wheel.set_flip_h(true)
  velocity.x = velocity_x_calc(current_x_input, delta)
  if Input.is_action_just_pressed("jump"):
    jump_input_pressed()
  add_gravity_velocity(delta)
  if not is_zero_approx(velocity.x) and is_on_floor() and velocity.x > 0:
    animation_player.play(&"walk_right_wheel")
  elif not is_zero_approx(velocity.x) and is_on_floor() and velocity.x < 0:
    animation_player.play(&"walk_left_wheel")
  elif is_on_floor():
    animation_player.play(&"idle_wheel")
  move_and_slide()
