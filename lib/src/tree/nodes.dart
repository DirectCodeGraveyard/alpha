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
  
  void printGraph() {
    printTree(_createGraphSection());
  }
  
  Map<String, dynamic> _createGraphSection() {
    var section = {
      "label": toString()
    };
    
    section["nodes"] = children.map((child) {
      return child._createGraphSection();
    }).toList(growable: true);
    
    return section;
  }
  
  String toString() {
    return name;
  }
}

class Tree {
  final TreeNode root;
  
  Tree() : root = new TreeNode.root();
  Tree.withRoot(this.root);
}