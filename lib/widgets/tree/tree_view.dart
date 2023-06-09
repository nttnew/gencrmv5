import 'package:flutter/material.dart';
import './tree_node.dart';
import 'tree_node_model.dart';

class TreeView extends StatefulWidget {
  final List<TreeNodeData> data;
  final bool lazy;
  final Widget icon;
  final double offsetLeft;
  final bool showFilter;
  final bool showActions;
  final bool showCheckBox;

  final Function(TreeNodeData node, int index)? onTap;
  final void Function(TreeNodeData node)? onLoad;
  final void Function(TreeNodeData node)? onExpand;
  final void Function(TreeNodeData node)? onCollapse;
  final void Function(bool checked, TreeNodeData node, int index,
      TreeNodeData p, List<TreeNodeData> lp)? onCheck;
  final void Function(TreeNodeData node, TreeNodeData parent)? onAppend;
  final void Function(TreeNodeData node, TreeNodeData parent)? onRemove;

  final TreeNodeData Function(TreeNodeData parent)? append;
  final Future<List<TreeNodeData>> Function(TreeNodeData parent)? load;

  const TreeView({
    Key? key,
    required this.data,
    this.onTap,
    this.onCheck,
    this.onLoad,
    this.onExpand,
    this.onCollapse,
    this.onAppend,
    this.onRemove,
    this.append,
    this.load,
    this.lazy = false,
    this.offsetLeft = 24.0,
    this.showFilter = false,
    this.showActions = false,
    this.showCheckBox = false,
    this.icon = const Icon(Icons.expand_more, size: 16.0),
  }) : super(key: key);

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  List<TreeNodeData> _renderList = [];

  List<TreeNodeData> _filter(String val, List<TreeNodeData> list) {
    List<TreeNodeData> temp = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].title.contains(val)) {
        temp.add(list[i]);
      }
      if (list[i].children.isNotEmpty) {
        list[i].children = _filter(val, list[i].children);
      }
    }
    return temp;
  }

  void _onChange(String val) {
    if (val.isNotEmpty) {
      _renderList = _filter(val, _renderList);
    } else {
      _renderList = widget.data;
    }
  }

  void append(TreeNodeData parent) {
    parent.children.add(widget.append!(parent));
  }

  void _remove(TreeNodeData node, List<TreeNodeData> list) {
    for (int i = 0; i < list.length; i++) {
      if (node == list[i]) {
        list.removeAt(i);
      } else {
        _remove(node, list[i].children);
      }
    }
  }

  void remove(TreeNodeData node) {
    _remove(node, _renderList);
  }

  Future<bool> load(TreeNodeData node) async {
    try {
      final data = await widget.load!(node);
      node.children = data;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _renderList = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showFilter)
          Container(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 18.0,
              bottom: 12.0,
            ),
            child: TextField(onChanged: _onChange),
          ),
        ...List.generate(
          _renderList.length,
          (int index) {
            return TreeNode(
              load: load,
              remove: remove,
              append: append,
              parent: _renderList[index],
              data: _renderList[index],
              icon: widget.icon,
              lazy: widget.lazy,
              offsetLeft: widget.offsetLeft,
              showCheckBox: widget.showCheckBox,
              showActions: widget.showActions,
              onTap: widget.onTap ?? (n, index) {},
              onLoad: widget.onLoad ?? (n) {},
              onCheck: widget.onCheck ?? (b, n, index, p, lp) {},
              onExpand: widget.onExpand ?? (n) {},
              onRemove: widget.onRemove ?? (n, p) {},
              onAppend: widget.onAppend ?? (n, p) {},
              onCollapse: widget.onCollapse ?? (n) {},
              index: index,
              listParent: _renderList,
            );
          },
        )
      ],
    );
  }
}
