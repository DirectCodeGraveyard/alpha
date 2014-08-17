part of alpha.html;

final BoxManager boxManager = new BoxManager();

class BoxManager {
  final List<Box> boxes = [];
  
  BoxManager();
  
  Box create(int width, int height) {
    var box = new Box(new DivElement()..style.width = width.toString() + "px"..style.height = height.toString() + "px");
    boxes.add(box);
    box.setBorderEnabled(true);
    return box;
  }
  
  int indexOf(Box box) => boxes.indexOf(box);
  
  void remove(Box box) {
    var index = indexOf(box);
    if (index != -1) {
      box.element.remove();
      boxes.removeAt(index);
    }
  }
  
  Box clone(Box orig) {
    var box = create(pixelsToInteger(orig.element.style.width), pixelsToInteger(orig.element.style.height));
    if (orig.element.parent != null) {
      box.appendTo(orig.element.parent);
    }
    box.element.innerHtml = orig.element.innerHtml;
    box.enableDragging(orig._dropzone);
    box._drag.avatarHandler = orig._drag.avatarHandler;
    box.element.style.setProperty("color", orig.element.style.color);
    box.element.style.setProperty("background-color", orig.element.style.backgroundColor);
    box.element.style.marginBottom = orig.element.style.marginBottom;
    return box;
  }
  
  void moveApart(int pixels) {
    for (var box in boxes) {
      box.element.style.marginBottom = "${pixels}px";
    }
  }
  
  void multiply(Box orig, int times) {
    for (int i = 1; i <= times; i++) {
      clone(orig);
    }
  }
}

class Box {
  final Element element;
  Draggable _drag;
  Dropzone _dropzone;
  
  Box(this.element);
  
  void setColor(String color, {bool background: false}) {
    background ? element.style.backgroundColor = color : element.style.color = color;
  }
  
  void setBorderEnabled(bool border) {
    if (border) {
      element.style
        ..border = "thin"
        ..borderStyle = "solid";
    } else {
      element.style
        ..removeProperty("border")
        ..removeProperty("border-style");
    }
  }
  
  void appendTo(Element target) {
    target.append(element);
  }
  
  void setTextContent(String content) {
    element.text = content;
  }
  
  void enableDragging(Dropzone drop) {
    _dropzone = drop;
    _drag = new Draggable(element, avatarHandler: new AvatarHandler.original());
  }
  
  void disableDragging() {
    _drag.destroy();
    _dropzone.destroy();
    _drag = null;
    _dropzone = null;
  }
}