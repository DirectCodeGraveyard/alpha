import "package:alpha/tree.dart";

void main() {
  var tree = new Tree();

  tree.root.newChild(name: "Child A").newChild(name: "Child A #1");
  tree.root.newChild(name: "Child B").newChild(name: "Child B #1");
  tree.root.newChild(name: "Child C").newChild(name : "Child C #1");
  
  var tree2 = new Tree();

  tree2.root.newChild(name: "Child A").newChild(name: "Child A #1");
  tree2.root.newChild(name: "Child B").newChild(name: "Child B #1");
  tree2.root.newChild(name: "Child C").newChild(name : "Child C #1");
  tree.printGraph();
  tree2.printGraph();
}