part of alpha.html;

/**
 * Applies [properties] to the given [selector].
 * 
 * A value of null for a property removes it.
 */
void css(String selector, Map<String, String> properties) {
  var style = querySelector(selector).style;
  properties.forEach((key, value) {
    if (value == null) {
      style.removeProperty(key);
    } else {
      style.setProperty(key, value);
    }
  });
}

int pixelsToInteger(String input) {
  return int.parse(input.substring(0, input.length - 2));
}