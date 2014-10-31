import "package:alpha/tree.dart";

void main() {
  var tree = new Tree();
  
  print("Adding 3 children to the root node.");
  tree.root.newChild(name: "Child A").newChild(name: "Child A #1");
  tree.root.newChild(name: "Child B").newChild(name: "Child B #1");
  tree.root.newChild(name: "Child C").newChild(name : "Child C #1");
  
  print("Root Node is equal to Root Node: ${tree.root == tree.root}");
  print("Root Node is not equal to another Root Node: ${tree.root != new TreeNode.root()}");
  tree.printGraph();
  print("Tree is cyclic: ${tree.isCyclic()}");
  print("Adding Root Node as a child of Root Node");
  tree.root.addChild(tree.root);
  print("Tree is cyclic: ${tree.isCyclic()}");
}