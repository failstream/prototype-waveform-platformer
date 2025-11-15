## base_character.gd


@abstract class_name BaseCharacter
extends CharacterBody2D


@export_group("Jump")
@export var jump_pixel_height: float = 256.0
@export var time_to_peak: float = 0.6
@export var time_to_descent: float = 0.4
@export var terminal_velocity: float = 700.0

var jump_velocity: float
var jump_gravity_magnitude: float
var fall_gravity_magnitude: float

@export_group("Run")
@export var horizontal_top_speed: float = 500.0
@export var time_to_top_speed: float = 0.0
@export var time_to_stop: float = 0.0


@export_group("Waves")
@export var signal_range: float = 500.0
@export var stop_movement_when_not_in_range: bool = true
@export var can_in_air_jump_with_signal: bool = false
@export var valid_signals: Array[SIGNALS] = []

enum SIGNALS { JUMP, RIGHT, LEFT, STILL }

@export_group("")
## Determines if this character starts as player controlled.
@export var start_as_player_controlled: bool = false
@export var can_be_player_controlled: bool = true
@export var can_receive_signals: bool = true
@export var can_toggle_sending: bool = true
@export var hitbox: Area2D
@export var debug: bool = false

## Determines if this character is currently player controlled.
var _is_player_controlled: bool = false

## Determines if this character can be player controlled
var _can_be_player_controlled: bool = false

## Determines if this character is currently allowed to receive signals.
var _is_currently_receiving: bool = false

## Determines if this character is currently allowed to send signals.
var _is_currently_sending: bool = false

## Determines if this character can toggle sending messages when player controlled.
var _can_toggle_sending: bool = true

signal received_wave
var _signal_x_input: int = 0


#region Godot Overrides


func _ready() -> void:
  
  connect(&"received_wave", _received_wave, CONNECT_PERSIST)
  calculate_jump_velocities()
  _can_be_player_controlled = can_be_player_controlled
  _can_toggle_sending = can_toggle_sending
  if start_as_player_controlled:
    assert(LevelManager.current_level_root.current_player == null)
    _is_player_controlled = true
    _is_currently_sending = true
    LevelManager.current_level_root.current_player = self
  else:
    _is_currently_receiving = true
  LevelManager.current_level_root.all_characters.append(self)


func _exit_tree() -> void:
  
  if _is_player_controlled:
    LevelManager.current_level_root.current_player = null
  LevelManager.current_level_root.all_characters.remove_at(LevelManager.current_level_root.all_characters.find(self))


func _draw() -> void:
  
  if _is_currently_sending:
    draw_circle(to_local(global_position), signal_range, Color.DARK_RED, false, 2.0, true)


func _process(_delta: float) -> void:
  if debug:
    queue_redraw()


#region Physics Calculations


## [br]Calculates the x velocity from [param current_input] and [member time_to_top_speed],[br]
## [member time_to_stop], [member horizontal_top_speed], If either of the times is zero,[br]
## then the respective acceleration/deceleration is instant.
func velocity_x_calc(current_input: int, delta: float) -> float:
  
  var acceleration: float = 0.0 if is_zero_approx(time_to_top_speed) else horizontal_top_speed / time_to_top_speed
  var deceleration: float = 0.0 if is_zero_approx(time_to_stop) else horizontal_top_speed / time_to_stop
  
  if current_input == 0:
    if is_zero_approx(time_to_stop):
      return 0.0
    return move_toward(velocity.x, 0.0, delta * deceleration)
  else:
    if is_zero_approx(time_to_top_speed):
      return horizontal_top_speed * current_input
    return move_toward(velocity.x, horizontal_top_speed * current_input, delta * acceleration)



## [br]Calculates the gravity for the body when jumping and when falling and adds it to velocity.y.
func add_gravity_velocity(delta: float) -> void:
  
  if velocity.y < 0.0 and not is_on_floor():
    velocity.y += move_toward(0.0, terminal_velocity, jump_gravity_magnitude * delta)
  elif not is_on_floor():
    velocity.y += move_toward(0.0, terminal_velocity, fall_gravity_magnitude * delta)



## [br]calculates gravity magnitudes for rising and falling as well as initial jump velocity from
## the exported jump variables.
func calculate_jump_velocities() -> void:
  
  jump_velocity = ((2.0 * jump_pixel_height) / time_to_peak) * -1.0
  jump_gravity_magnitude = ((-2.0 * jump_pixel_height) / (time_to_peak * time_to_peak)) * -1.0
  fall_gravity_magnitude = ((-2.0 * jump_pixel_height) / (time_to_descent * time_to_descent)) * -1.0


## [br]Called when the body jumps
func jump() -> void:
  velocity.y = jump_velocity
  if _is_currently_sending:
    send_wave(SIGNALS.JUMP)


#region Player Input

## This is a wrapper for getting the x_input. If this character is player controlled it gets the[br]
## player input, otherwise it uses the [member _signal_x_input]
func get_x_input() -> int:
  
  if _is_player_controlled:
    return _get_player_x_input()
  if stop_movement_when_not_in_range and not is_in_transmitter_range():
    _signal_x_input = 0
  return _signal_x_input


func jump_input_pressed() -> void:
  
  if _is_player_controlled and is_on_floor():
    jump()


func toggle_wave_pressed() -> void:
  
  if _is_player_controlled and _can_toggle_sending:
    _toggle_transmission()


func swap_character_pressed() -> void:
  
  if not LevelManager.current_level_root.swap_character_timer.is_stopped():
    return
  if _is_player_controlled:
    var nearest_char: BaseCharacter = _find_nearest_swappable_character()
    if nearest_char != null:
      _swap_player_control(nearest_char)
      LevelManager.current_level_root.swap_character_timer.start()


## This gets the player_x_input and returns it.
func _get_player_x_input() -> int:
  
  var move_input = 0
  if Input.is_action_pressed("left"):
    move_input -= 1
  if Input.is_action_pressed("right"):
    move_input += 1
  send_x_input_signal(move_input)
  return move_input



#region Character Swapping


func _swap_player_control(new_character: BaseCharacter) -> void:
  
  var current_player_controlled: BaseCharacter = LevelManager.current_level_root.current_player
  current_player_controlled._is_player_controlled = false
  if current_player_controlled.can_receive_signals:
    current_player_controlled._is_currently_receiving = true
  new_character._is_player_controlled = true
  new_character._is_currently_receiving = false
  LevelManager.current_level_root.current_player = new_character


## returns the nearest character that can currently be swapped to. Returns null if no character found.
func _find_nearest_swappable_character() -> BaseCharacter:
  
  var other_characters: Array[BaseCharacter] = LevelManager.current_level_root.all_characters
  var character: BaseCharacter = null
  var character_distance: float = -1.0
  for body in other_characters:
    if not body._can_be_player_controlled or body == self:
      continue
    var distance: float = abs(body.global_position.distance_to(self.global_position))
    if character == null:
      character = body
      character_distance = distance
    elif distance < character_distance:
      character = body
      character_distance = distance
  return character



#region Wave Signal Propagation


## Reads the x_input passed in and then sends the appropriate signal out.
func send_x_input_signal(current_input: int) -> void:
  
  if current_input == 1:
    send_wave(SIGNALS.RIGHT)
  elif current_input == -1:
    send_wave(SIGNALS.LEFT)
  else:
    send_wave(SIGNALS.STILL)
  return


func _toggle_transmission() -> void:
  
  set_transmission_status(not _is_currently_sending)


func set_transmission_status(value: bool) -> void:
  
  _is_currently_sending = value
  queue_redraw()


func set_transmission_toggle_capability(value: bool) -> void:
  
  _can_toggle_sending = value


func set_receiving_status(value: bool) -> void:
  
  _is_currently_receiving = value


## Called when this Character receives a wave from somewhere.
func _received_wave(type: SIGNALS, _data: Variant) -> void:
  
  if _is_player_controlled or not valid_signals.has(type):
    return
  if type == SIGNALS.JUMP:
    if not can_in_air_jump_with_signal and not is_on_floor():
      return
    jump()
  elif type == SIGNALS.RIGHT:
    _signal_x_input = 1
  elif type == SIGNALS.LEFT:
    _signal_x_input = -1
  elif type == SIGNALS.STILL:
    _signal_x_input = 0



## [br]Sends a wave of the signal [param type] to all Characters in range.
func send_wave(type: SIGNALS) -> void:
  
  if not _is_currently_sending:
    return
  
  for body in LevelManager.current_level_root.all_characters:
    if body == self or not body._is_currently_receiving:
      continue
    var distance: float = abs(body.global_position.distance_to(self.global_position))
    if distance < signal_range:
      body.received_wave.emit(type, [])


## [br]Checks if the current character is in range of a transmitting character
func is_in_transmitter_range() -> bool:
  
  for body in LevelManager.current_level_root.all_characters:
    if body == self or not body._is_currently_sending:
      continue
    var distance: float = abs(body.global_position.distance_to(self.global_position))
    if distance < body.signal_range:
      return true
  return false
