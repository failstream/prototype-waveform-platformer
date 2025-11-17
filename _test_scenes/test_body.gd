extends AnimatableBody2D

@onready var left_timer: Timer = $LeftTimer
@onready var right_timer: Timer = $RightTimer

func _ready() -> void:
  
  left_timer.start()


func _physics_process(delta: float) -> void:
  
  if not left_timer.is_stopped():
    global_position = global_position.move_toward(global_position + (Vector2.LEFT * 64), delta * 64)
  elif not right_timer.is_stopped():
    global_position = global_position.move_toward(global_position + (Vector2.RIGHT) * 64, delta * 64)




func _on_left_timer_timeout() -> void:
  right_timer.start()


func _on_right_timer_timeout() -> void:
  left_timer.start()
