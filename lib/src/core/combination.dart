part of alpha.core;

class CombinationLock {
  final List<int> _code;
  
  CombinationLock(this._code);
  
  static CombinationLock createRandom(int size, Acceptor<List<int>> callback) {
    var code = [];
    for (int i = 1; i<= size; i++) {
      code.add(new Random().nextInt(9));
    }
    callback(code);
    return new CombinationLock(code);
  }
  
  bool unlock(List<int> code) {
    return _code == code;
  }
}
