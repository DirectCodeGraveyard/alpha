import "dart:async";
import "dart:html";

import "package:alpha/html.dart";

void main() {
  var buttonExample = querySelector("#buttonExample");
  
  bool buttonExampleClick = false;
  
  buttonExample.onClick.listen((event) {
    if (buttonExampleClick) {
      return;
    }
    buttonExampleClick = true;
    buttonExample.text = "Clicked!";
    new Timer(new Duration(milliseconds: 1500), () {
      buttonExampleClick = false;
      buttonExample.text = "Click Me";
    });
  });
}