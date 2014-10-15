part of alpha.tree;

class TreeNode {
  final TreeNode parent;
  final List<TreeNode> children;
  
  TreeNode(this.parent) :
    children = [];
  
  TreeNode.root() :
    parent = null,
    children = [];
}
