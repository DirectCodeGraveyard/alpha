import "dart:html";
import "package:alpha/html.dart";
import "package:dnd/dnd.dart";

void main() {
  var box = boxManager.create(128, 128);
  box.appendTo(document.body);
  box.setColor("blue", background: true);
  box.enableDragging(new Dropzone(document.body));
  boxManager.multiply(box, 4);
  boxManager.moveApart(20);
  document.onKeyPress.where((it) => it.keyCode == 67).listen((e) {
    boxManager.clone(box);
  });
}