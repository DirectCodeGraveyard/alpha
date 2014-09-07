part of alpha.html;

abstract class GridPathFinderBase {
  Future goto(Point target);
}

class GridPathFinderAStar extends GridPathFinderBase {
  final Cursor cursor;
  final Grid grid;

  GridPathFinderAStar(this.grid, this.cursor);

  Future goto(Point<int> target) {
    StringBuffer MAZE = new StringBuffer();

    for (var row = 0; row < grid.rows; row++) {
      for (var column = 0; column < grid.columns; column++) {
        var point = new Point(column, row);

        if (point == target) {
          MAZE.write("g");
        } else if (point == cursor.position) {
          MAZE.write("s");
        } else if (grid.boxAt(point).isGrayedOut) {
          MAZE.write("x");
        } else {
          MAZE.write("o");
        }
      }
      MAZE.writeln();
    }

    var maze = new astar.Maze.parse(MAZE.toString());
    
    var solution = astar.aStar2D(maze);

    var completer = new Completer();
    new Timer.periodic(new Duration(milliseconds: 500), (Timer timer) {
      if (cursor.position == target) {
        timer.cancel();
        completer.complete();
        return;
      }

      var tile = solution.removeFirst();
      var c = new Point(tile.x, tile.y);

      cursor.moveToPoint(c);
    });
    return completer.future;
  }
}
