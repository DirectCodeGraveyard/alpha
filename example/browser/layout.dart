import "dart:html";
import "package:alpha/html.dart";
import "package:dnd/dnd.dart";

void main() {
  var box = boxManager.create(128, 128);
  box.appendTo(document.body);
  box.setColor("blue", background: true);
  box.enableDragging(new Dropzone(document.body));

  boxManager.moveApart(20);
  document.onKeyPress.where((it) => it.keyCode == 67).listen((e) {
    var newBox = boxManager.clone(box);
    var e = newBox.element;
    
    int i = 0;
    
    void callbackEnd(_) {
      if (i == 0) {
        e.style.removeProperty("transform");
        return;
      }
      
      e.style.transform = "translate(0, ${i}px)";
      window.requestAnimationFrame(callbackEnd);
      i--;
    }
    
    void callbackStart(_) {
      if (i == 5) {
        window.requestAnimationFrame(callbackEnd);
        return;
      }
      
      e.style.transform = "translate(0, ${i}px)";
      window.requestAnimationFrame(callbackStart);
      i++;
    }
    
    window.requestAnimationFrame(callbackStart);
  });
}