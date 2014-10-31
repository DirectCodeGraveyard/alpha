part of alpha.tree;

class TreeNode {
  final TreeNode parent;
  final List<TreeNode> _children;
  List<TreeNode> _childrenProtected;
  String name = "Unnamed";
  
  List<TreeNode> get children {
    if (_childrenProtected == null) {
      _childrenProtected = new UnmodifiableListView(_children);
    }
    return _childrenProtected;
  }
  
  TreeNode(this.parent) :
    _children = [] {
      parent.addChild(this);
    }
  
  TreeNode.asRoot(TreeNode root) :
    parent = null,
    _children = root.children;
  
  TreeNode._fromClone(this.parent, List<TreeNode> children) :
    _children = children;
  
  TreeNode.root() :
    parent = null,
    _children = [],
    name = "Root Node";
  
  bool get isRootNode => parent == null;
  bool get hasChildren => children.isNotEmpty;
  
  TreeNode clone() =>
      new TreeNode._fromClone(parent.clone(), _cloneChildren());
  
  List<TreeNode> _cloneChildren() =>
      children.map((child) => child.clone()).toList(growable: true);
  
  TreeNode newChild({String name}) {
    var node = new TreeNode(this);
    if (name != null) {
      node.name = name;
    }
    return node;
  }
  
  void addChild(TreeNode node, {String name}) {
    if (_children.contains(node)) {
      throw new StateError("Node is already a child.");
    }
    if (name != null) {
      node.name = name;
    }
    _children.add(node);
  }
  
  void printGraph({bool checkCyclic: true}) {
    if (checkCyclic && _checkCyclic(this)) {
      throw new StateError("Unable to print a cyclic graph!");
    }
    printTree(createTreeMap());
  }
  
  Map<String, dynamic> createTreeMap() {
    var section = {
      "label": toString()
    };
    
    section["nodes"] = children.map((child) {
      return child.createTreeMap();
    }).toList(growable: true);
    
    return section;
  }
  
  String createDotGraph() {
    var buff = new IndentedStringBuffer("  ");
    buff.writeln("digraph \"${name}\" {");
    buff.level++;
    buff.writeln("node [fontname=Helvetica];");
    buff.writeln("edge [fontname=Helvetica, fontcolor=gray];");
    
    List<TreeNode> queued = [this];
    
    while (queued.isNotEmpty) {
      var node = queued.removeAt(0);
      if (!node.isRootNode) {
        buff.writeln('"${node.parent.name}" -> "${node.name}";'); 
      }
      queued.addAll(node.children);
    }
    
    buff.level--;
    buff.writeln("}");
    return buff.toString();
  }
  
  String toString() {
    return name;
  }
}

bool _checkCyclic(TreeNode root) {
  List<TreeNode> visited = [];
  List<TreeNode> queued = [root];
  while (queued.isNotEmpty) {
    TreeNode current = queued.removeAt(0);
    visited.add(current);
    
    var cyclicParent = current.parent == current;
    
    if (cyclicParent) {
      return true;
    }
    
    var cyclicChildren = current.children.any((child) {
      return visited.contains(child);
    });
    
    if (cyclicChildren) {
      return true;
    }
    
    queued.addAll(current.children);
  }
  return false;
}

class Tree {
  final TreeNode root;
  
  Tree() : root = new TreeNode.root();
  Tree.withRoot(this.root);
  
  bool isCyclic() => _checkCyclic(root);
  
  void printGraph() => root.printGraph();
}