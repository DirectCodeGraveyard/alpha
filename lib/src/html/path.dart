part of alpha.html;

class PathFindingQueueItem {
  final Point<int> point;
  final int counter;

  PathFindingQueueItem(this.point, this.counter);
}

class GridPathFinderSimple extends GridPathFinderBase {
  final Cursor cursor;
  final Grid grid;
  CursorMoveHandler _actualOnMove;
  
  final StreamController<PathFindingQueueItem> _queueItem = new StreamController();
  final StreamController<GridSection> _boxScan = new StreamController();
  
  Stream<GridSection> get onBoxScan => _boxScan.stream;
  Stream<PathFindingQueueItem> get onNewQueueItem => _queueItem.stream;

  GridPathFinderSimple(this.grid, this.cursor);

  Future<List<PathFindingQueueItem>> findPathSimple(Point<int> target) {
    var completer = new Completer();
    List<PathFindingQueueItem> queue = [new PathFindingQueueItem(target, 0)];

    int i = 0;

    List<Point<int>> last = [];

    new Timer.periodic(new Duration(microseconds: 1), (Timer timer) {
      if (queue.length < i || last == queue) {
        timer.cancel();
        return;
      }
      
      last = new List.from(queue);
      
      var item = queue[i];
      var point = item.point;
      
      if (point == cursor.position) {
        timer.cancel();
        completer.complete(queue);
        return;
      }
      
      List<PathFindingQueueItem> adjacent = [new PathFindingQueueItem(new Point(point.x + 1, point.y), item.counter + 1), new PathFindingQueueItem(new Point(point.x - 1, point.y), item.counter + 1), new PathFindingQueueItem(new Point(point.x, point.y + 1), item.counter + 1), new PathFindingQueueItem(new Point(point.x, point.y - 1), item.counter + 1)];

      var toRemove = [];

      adjacent.forEach((it) {
        var rem = scan(it.point) || queue.any((a) {
          return (a.point == it.point) && (a.counter >= it.counter);
        });
        
        if (rem) {
          toRemove.add(it);
        }
      });

      for (var v in toRemove) adjacent.remove(v);

      queue.addAll(adjacent);

      adjacent.forEach((item) => _queueItem.add(item));
      
      i++;
    });
    
    return completer.future;
  }
  
  Future goto(Point<int> point) {
    var completer = new Completer();
    findPathSimple(point).then((List<PathFindingQueueItem> items) {
      new Timer.periodic(new Duration(milliseconds: 500), (Timer timer) {
        if (cursor.position == point) {
          timer.cancel();
          completer.complete();
          return;
        }
        
        var possible = items.where((it) {
          var dist = it.point.distanceTo(cursor.position);
          return dist.abs() <= 1;
        }).toList();
        possible.sort((a, b) => a.counter.compareTo(b.counter));
        var first = possible.first;
        cursor.moveToPoint(first.point);
      });
    });
    return completer.future;
  }

  bool scan(Point<int> point) {
    if (point.x < 0 || point.y < 0 || point.x > grid.columns - 1 || point.y > grid.rows - 1) {
      return true;
    }
    var box = grid.box(point.x, point.y);
    _boxScan.add(box);
    return box.isGrayedOut;
  }
}

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
