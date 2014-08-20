import "dart:html";
import "package:alpha/html.dart";
import "package:dnd/dnd.dart";

void main() {
  var mainBox = boxManager.create(64, 64);
  mainBox.appendTo(document.body);
  mainBox.setColor("blue", background: true);
  mainBox.enableDragging(new Dropzone(document.body));

  boxManager.moveApart(20);
  document.onKeyPress.where((it) => it.keyCode == 67).listen((e) {
    var newBox = boxManager.clone(mainBox);
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
      if (i == 7) {
        window.requestAnimationFrame(callbackEnd);
        return;
      }
      
      e.style.transform = "translate(0, ${i}px)";
      window.requestAnimationFrame(callbackStart);
      i++;
    }
    
    window.requestAnimationFrame(callbackStart);
  });
  
  document.onKeyPress.where((e) => e.keyCode == 82).listen((e) {
    var boxes = new List.from(boxManager.boxes);
    boxes.forEach((box) {
      if (mainBox != box) {
        boxManager.remove(box);
      }
    });
  });
}