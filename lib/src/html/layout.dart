part of alpha.html;

bool elementsCollide(Element left, Element right) {
  var leftOffsetBottom = left.offsetTop + left.offsetHeight;
  var leftOffsetRight = left.offsetLeft + left.offsetWidth;
  var rightOffsetBottom = right.offsetTop + right.offsetHeight;
  var rightOffsetRight = right.offsetLeft + right.offsetWidth;
  
  return !(
      leftOffsetBottom < right.offsetTop ||
      left.offsetTop > rightOffsetBottom ||
      leftOffsetRight < right.offsetLeft ||
      left.offsetLeft > rightOffsetRight
  );
}