import "dart:html";
import "package:alpha/html.dart";

// 0 is target. 1 is wall.
int toolMode = 0;

bool scanningColor = true;

Grid grid;
Cursor cursor;
GridPathFinderBase pathFinder;

bool useAStar = true;

var INIT_WALL_GRAPH = [
  [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];

void main() {
  querySelector("#switchToolMode").onClick.listen((event) {
    toolMode = toolMode == 0 ? 1 : 0;
    if (toolMode == 0) {
      querySelector("#toolMode").text = "select target";
    } else if (toolMode == 1) {
      querySelector("#toolMode").text = "add walls";
    }
  });
  
  querySelector("#toggleScanningColor").onClick.listen((event) {
    scanningColor = !scanningColor;
    querySelector("#showScanningColors").text = scanningColor.toString();
  });
  
  querySelector("#clearWalls").onClick.listen((event) {
    grid.eachBox((box) => box.ungrayOut());
  });
  
  querySelector("#switchStrategy").onClick.listen(updatePathFinder);
  
  var pointImg = new ImageElement(src: "img/point.png", width: 16, height: 16);

  pointImg.style
      ..paddingLeft = "8px"
      ..paddingRight = "8px"
      ..paddingTop = "8px"
      ..paddingBottom = "8px";


  var container = querySelector("#container");
  grid = new Grid(container, 20, 20);
  
  grid.interpretWallGraph(INIT_WALL_GRAPH);
  
  grid.draw();

  grid.eachBox((box) {
    box.activateBorder("solid 1.5px");
    
    box.onClick.listen((e) => onBoxClick(box, e));
  });

  cursor = new BasicCursor(new Point(1, 1), (Point<int> originalPosition, Point<int> position) {
    if (originalPosition != null) {
      var orig = grid.box(originalPosition.x, originalPosition.y);
      orig.element.children.remove(pointImg);
    }

    var now = grid.box(position.x, position.y);
    now.element.append(pointImg);
    querySelector("#position").text = "(${position.x}, ${position.y})";
  });
  
  updatePathFinder();
}

void updatePathFinder([e]) {
  useAStar = !useAStar;
  if (useAStar) {
    pathFinder = new GridPathFinderAStar(grid, cursor);
  } else {
    pathFinder = new GridPathFinder(grid, cursor);
  }
  
  if (pathFinder is GridPathFinder) {
    GridPathFinder p = pathFinder;
    p.onBoxScan.listen((box) {
      if (!box.isGrayedOut && scanningColor) {
        box.blinkColor("cyan", time: 100); 
      }
    });
    
    p.onNewQueueItem.listen((item) {
      if (scanningColor) {
        grid.box(item.point.x, item.point.y).blinkColor("orange", time: 250, border: true);
      }
    });
  }
  
  querySelector("#strategy").text = useAStar ? "A*" : "Simple";
}

void onBoxClick(GridSection box, MouseEvent event) {
  if (toolMode == 0) {
    var target = new Point<int>(box.x, box.y);
    
    box.style.borderColor = "red";
    
    pathFinder.goto(target).then((_) {
      box.style.removeProperty("border-color");
    });
  } else if (toolMode == 1) {
    if (box.isGrayedOut) {
      box.ungrayOut();
    } else {
      box.grayOut();
    }
  }
}