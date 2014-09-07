part of alpha.html;

abstract class Asset {
  void load();
  void destroy();
}

class SoundAsset extends Asset {
  final String src;
  
  AudioElement _audio;
  
  Stream get onPlay => audio.onPlay;
  Stream get onPlaying => audio.onPlaying;
  Stream get onEnd => audio.onEnded;
  Stream get onLoaded => audio.onLoadedData;
  
  SoundAsset(this.src);
  
  @override
  void load() {
    var completer = new Completer();
    
    if (_audio == null) {
      _audio = new AudioElement(src);
      _audio.load();
      _audio.onLoadedData.listen((event) {
        completer.complete();
      });
    } else {
      completer.complete();
    }
    
    return completer.future;
  }
  
  void play({bool loop: false}) {
    audio.loop = loop;
    audio.play();
  }
  
  AudioElement get audio => _audio;
  
  @override
  void destroy() {
    _audio = null;
  }
}
