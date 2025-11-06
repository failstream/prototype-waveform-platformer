## base_character.gd


@abstract class_name BaseCharacter
extends CharacterBody2D

@export var jump_pixel_height: float = 256.0
@export var time_to_peak: float = 0.6
@export var time_to_descent: float = 0.4
@export var terminal_velocity: float = 700.0

@export var horizontal_top_speed: float = 500.0
@export var time_to_top_speed: float = 0.5
@export var time_to_stop: float = 0.3

@export var wave_distance: float = 500.0

var jump_velocity: float
var jump_gravity_magnitude: float
var fall_gravity_magnitude: float


@export var start_as_player_controlled: bool = false
@export var valid_signals: Array[SIGNALS] = []


var _is_player_controlled: bool = false

var is_currently_receiving: bool = false
var is_currently_sending: bool = false

enum SIGNALS { JUMP, RIGHT, LEFT, STILL }


var _move_input: int = 0

signal received_wave
var _signal_input: int = 0


func get_input() -> int:
  
  if _is_player_controlled:
    return _get_player_input()
  return _signal_input
  

func _received_wave(type: SIGNALS, data: Variant) -> void:
  
  if _is_player_controlled:
    return
  if type == SIGNALS.JUMP:
    jump()
  elif type == SIGNALS.RIGHT:
    _signal_input = 1
  elif type == SIGNALS.LEFT:
    _signal_input = -1
  elif type == SIGNALS.STILL:
    _signal_input = 0


func _get_player_input() -> int:
  
  _move_input = 0
  if Input.is_action_pressed("ui_left"):
    _move_input -= 1
  if Input.is_action_pressed("ui_right"):
    _move_input += 1
  if _move_input == 1:
    send_wave(SIGNALS.RIGHT)
  elif _move_input == -1:
    send_wave(SIGNALS.LEFT)
  else:
    send_wave(SIGNALS.STILL)
  return _move_input


func _ready() -> void:
  
  connect(&"received_wave", _received_wave, CONNECT_PERSIST)
  calculate_jump_velocities()
  if start_as_player_controlled:
    assert(Waves.current_player == null)
    _is_player_controlled = true
    is_currently_sending = true
    Waves.current_player = self
  Waves.all_characters.append(self)


func horizontal_speed_calc(_input: int, _delta: float) -> void:
  
  #var acceleration: float = 0.0 if is_zero_approx(time_to_top_speed) else horizontal_top_speed / time_to_top_speed
  #var deceleration: float = 0.0 if is_zero_approx(time_to_stop) else horizontal_top_speed / time_to_stop
  
  if _input == 0:
    #velocity.x = move_toward(velocity.x, 0.0, delta * deceleration)
    velocity.x = 0.0
  else:
    #velocity.x = move_toward(velocity.x, horizontal_top_speed * _input, delta * acceleration)
    velocity.x = horizontal_top_speed * _input


func gravity_calc(delta: float) -> void:
  
  if velocity.y < 0.0 and not is_on_floor():
    velocity.y += rising_speed_delta(delta)
  elif not is_on_floor():
    velocity.y += falling_speed_delta(delta)


func jump() -> void:
  velocity.y = jump_velocity
  if is_currently_sending:
    send_wave(SIGNALS.JUMP)

func calculate_jump_velocities() -> void:
  
  jump_velocity = ((2.0 * jump_pixel_height) / time_to_peak) * -1.0
  jump_gravity_magnitude = ((-2.0 * jump_pixel_height) / (time_to_peak * time_to_peak)) * -1.0
  fall_gravity_magnitude = ((-2.0 * jump_pixel_height) / (time_to_descent * time_to_descent)) * -1.0
  

func falling_speed_delta(delta: float) -> float:
  return move_toward(0.0, terminal_velocity, fall_gravity_magnitude * delta)

func rising_speed_delta(delta: float) -> float:
  return move_toward(0.0, terminal_velocity, jump_gravity_magnitude * delta)


func send_wave(type: SIGNALS) -> void:
  
  for body in Waves.all_characters:
    var distance: float = abs(body.global_position.distance_to(self.global_position))
    if body != self and distance < wave_distance:
      body.received_wave.emit(type, [])
