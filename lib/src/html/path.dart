part of alpha.html;

typedef CursorMoveHandler(Point original, Point point);

abstract class Cursor {
  Point<int> get position;
  CursorMoveHandler onMove;
  
  Cursor(this.onMove);
  
  void moveTo(int x, int y);
  
  void moveToPoint(Point point) => moveTo(point.x, point.y);
  
  void moveLeft() => moveTo(position.x - 1, position.y);
  void moveRight() => moveTo(position.x + 1, position.y);
  void moveUp() => moveTo(position.x, position.y - 1);
  void moveDown() => moveTo(position.x, position.y + 1);
}

class BasicCursor extends Cursor {
  Point<int> _position;
  Point<int> get position => _position;
  
  BasicCursor(Point<int> startPosition, CursorMoveHandler mover) : super(mover) {
    moveTo(startPosition.x, startPosition.y);
  }
  
  void moveTo(int x, int y) {
    var orig = _position;
    _position = new Point<int>(x, y);
    if (onMove != null) {
      onMove(orig, _position);
    }
  }
}

class QueuedCursor extends BasicCursor {
  final List<Action> moves = [];
  
  QueuedCursor(Point<int> startPosition, CursorMoveHandler mover) : super(startPosition, mover) {
    moveTo(startPosition.x, startPosition.y);
  }
  
  @override
  void moveTo(int x, int y) {
    _position = new Point(x, y);
    moves.add(() => super.moveTo(x, y));
  }
}