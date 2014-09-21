import "package:alpha/speech.dart";

void main() {
  SpeechCommander commander = new SpeechCommander();
  
  commander.initialize();
  commander.start();
  
  commander.registerCommand("hello", () {
    commander.say("Hello World!");
  });
}