extends BaseCharacter


func _physics_process(delta: float) -> void:
  
  var current_x_input: int = get_x_input()
  if current_x_input != 0:
    pass
  velocity.x = velocity_x_calc(current_x_input, delta)
  if _is_player_controlled and Input.is_action_just_pressed("ui_accept") and is_on_floor():
    jump()
  add_gravity_velocity(delta)
  move_and_slide()
