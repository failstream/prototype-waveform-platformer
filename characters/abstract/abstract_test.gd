extends BaseCharacter


func _physics_process(delta: float) -> void:
  
  var current_input: int = get_input()
  horizontal_speed_calc(current_input, delta)
  if _is_player_controlled and Input.is_action_just_pressed("ui_accept") and is_on_floor():
    jump()
  gravity_calc(delta)
  move_and_slide()
