part of alpha.track;

class Switch {
  bool _state;
  
  Switch(bool state) : _state = state;
  
  void on() {
    if (_state == true) {
      throw new StateError("Switch is already turned on!");
    }
    
    _state = true;
  }
  
  void off() {
    if (_state == false) {
      throw new StateError("Switch is already turned off!");
    }
  }
  
  bool toggle() => _state = !_state;
  
  bool get isOn => _state;
  bool get isOff => !isOn;
}