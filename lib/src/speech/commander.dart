part of alpha.speech;

typedef void SpeechCommandHandler();

class SpeechCommander {
  final SpeechRecognition recognizer;
  
  final Map<String, SpeechCommandHandler> commands = {};
  
  SpeechCommander() : recognizer = new SpeechRecognition();
  
  bool isPaused = false;
  
  void initialize() {
    recognizer.lang = "en-US";
    recognizer.maxAlternatives = 5;
    recognizer.continuous = true;
    
    recognizer.onResult.listen((event) {
      if (isPaused) return;
      
      var actual = event.results[event.resultIndex];
      var results = new List<SpeechRecognitionAlternative>.generate(actual.length, (i) => actual.item(i));
      
      results.sort((resultA, resultB) {
        return resultB.confidence.compareTo(resultA.confidence);
      });
      
      results.removeWhere((it) => it.confidence < 0.5);
      
      if (results.isNotEmpty) {
        var mostLikely = results.first.transcript.trim();
        
        print("Speech Recognized: ${mostLikely}");
        
        if (commands.containsKey(mostLikely)) {
          commands[mostLikely]();
        } 
      }
    });
  }
  
  void say(String text) {
    var synthesizer = window.speechSynthesis;
    var utterance = new SpeechSynthesisUtterance(text);
    utterance.onStart.listen((event) {
      recognizer.stop();
    });
    
    utterance.onEnd.listen((event) {
      recognizer.start();
    });
    
    synthesizer.speak(utterance);
  }
  
  void start() {
    recognizer.start();
  }
  
  void registerCommand(String name, SpeechCommandHandler handler) {
    commands[name] = handler;
  }
  
  void stop() {
    recognizer.stop();
  }
}