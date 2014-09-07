part of alpha.html;

class Grid {
  final List<List<GridSection>> sections;
  final DivElement container;
  final int columns;
  final int rows;

  Grid(this.container, this.columns, this.rows) : sections = [] {
    for (var column = 0; column < columns; column++) {
      sections.add([]);
      for (var row = 0; row < rows; row++) {
        sections[column].add(new GridSection(column, row, new DivElement()));
      }
    }

    var style = container.style;
    style
        ..display = "flex"
        ..flexDirection = "row";
  }

  void draw({int boxWidth: 32, int boxHeight: 32}) {
    container.style.width = "${boxWidth * columns}px";
    container.style.height = "${boxHeight * rows}px";

    for (var column in sections) {
      var ce = new DivElement();
      ce.classes.add("grid-column");
      ce.style.display = "flex";
      ce.style.flexDirection = "column";
      ce.style.width = "${boxWidth}px";

      for (var row in column) {
        row.element.style.width = "${boxWidth}px";
        row.element.style.height = "${boxHeight}px";
        ce.append(row.element);
      }

      container.append(ce);
    }
  }

  GridSection box(int x, int y) => sections[x][y];
  GridSection boxAt(Point<int> point) => box(point.x, point.y);

  void eachBox(void handler(GridSection box)) {
    sections.forEach((column) {
      column.forEach(handler);
    });
  }
  
  void interpretWallGraph(List<List<int>> graph) {
    for (int row = 0; row < graph[row].length; row++) {
      for (int column = 0; column < graph[row].length; column++) {
        if (graph[row][column] == 1) {
          box(column, row).grayOut();
        } else {
          box(column, row).ungrayOut();
        }
      }
    }
  }
}

class GridSection {
  final DivElement element;
  final int x;
  final int y;
  String _lastBackgroundColor;
  bool isGrayedOut = false;

  GridSection(this.x, this.y, this.element);

  CssStyleDeclaration get style => element.style;

  void activateBorder(String value) {
    style.border = value;
  }

  void grayOut() {
    if (isGrayedOut) return;
    isGrayedOut = true;
    _lastBackgroundColor = style.backgroundColor;
    style.backgroundColor = "gray";
  }

  void ungrayOut() {
    if (!isGrayedOut) return;
    isGrayedOut = false;
    if (_lastBackgroundColor != null) {
      style.backgroundColor = _lastBackgroundColor;
    } else {
      style.removeProperty("background-color");
    }
  }

  void blinkColor(String color, {int time: 250, bool border: false}) {
    if (border) {
      style.borderColor = color;
      new Timer(new Duration(milliseconds: time), () {
        style.removeProperty("border-color");
      });
    } else {
      style.backgroundColor = color;
      new Timer(new Duration(milliseconds: time), () {
        if (isGrayedOut) {
          style.backgroundColor = "gray";
        } else {
          style.removeProperty("background-color");
        }
      }); 
    }
  }

  Stream<MouseEvent> get onClick => element.onClick;
  Stream<MouseEvent> get onMouseEnter => element.onMouseEnter;
  Stream<MouseEvent> get onMouseLeave => element.onMouseLeave;
}

