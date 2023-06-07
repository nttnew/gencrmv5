import 'package:flutter/material.dart';
import '../../src/icon_constants.dart';
import 'tree_node_model.dart';

class TreeNode extends StatefulWidget {
  final TreeNodeData data;
  final TreeNodeData parent;
  final List<TreeNodeData> listParent;

  final bool lazy;
  final Widget icon;
  final bool showCheckBox;
  final bool showActions;
  final double offsetLeft;
  final int index;

  final Function(TreeNodeData node, int index) onTap;
  final void Function(bool checked, TreeNodeData node, int index,
      TreeNodeData p, List<TreeNodeData> lp) onCheck;

  final void Function(TreeNodeData node) onExpand;
  final void Function(TreeNodeData node) onCollapse;

  final Future Function(TreeNodeData node) load;
  final void Function(TreeNodeData node) onLoad;

  final void Function(TreeNodeData node) remove;
  final void Function(TreeNodeData node, TreeNodeData parent) onRemove;

  final void Function(TreeNodeData node) append;
  final void Function(TreeNodeData node, TreeNodeData parent) onAppend;

  const TreeNode({
    Key? key,
    required this.data,
    required this.parent,
    required this.offsetLeft,
    required this.showCheckBox,
    required this.showActions,
    required this.icon,
    required this.lazy,
    required this.load,
    required this.append,
    required this.remove,
    required this.onTap,
    required this.onCheck,
    required this.onLoad,
    required this.onExpand,
    required this.onAppend,
    required this.onRemove,
    required this.onCollapse,
    required this.index,
    required this.listParent,
  }) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  bool _isExpand = false;
  bool _isChecked = false;
  bool _showLoading = false;
  Color _bgColor = Colors.transparent;
  late AnimationController _rotationController;
  late final Tween<double> _turnsTween;
  late final List<TreeNodeData> _listChild;

  @override
  void didUpdateWidget(covariant TreeNode oldWidget) {
    _isChecked = widget.data.checked;
    super.didUpdateWidget(oldWidget);
  }

  @override
  initState() {
    _turnsTween = Tween<double>(begin: -0.25, end: 0.0);
    _listChild = widget.data.children;
    _isExpand = widget.data.expaned;
    _isChecked = widget.data.checked;
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onExpand(widget.data);
        } else if (status == AnimationStatus.reverse) {
          widget.onCollapse(widget.data);
        }
      });
    if (_isExpand) {
      _rotationController.forward();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: _bgColor,
          margin: const EdgeInsets.only(bottom: 2.0),
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.data.children.isNotEmpty
                  ? RotationTransition(
                      child: IconButton(
                        iconSize: 20,
                        icon: widget.icon,
                        onPressed: () {
                          widget.onTap(widget.data, widget.index);
                          if (widget.lazy && widget.data.children.isEmpty) {
                            _showLoading = true;
                            widget.load(widget.data).then((value) {
                              if (value) {
                                _isExpand = true;
                                _rotationController.forward();
                                widget.onLoad(widget.data);
                              }
                              _showLoading = false;
                            });
                          } else {
                            _isExpand = !_isExpand;
                            if (_isExpand) {
                              _rotationController.forward();
                            } else {
                              _rotationController.reverse();
                            }
                          }
                        },
                      ),
                      turns: _turnsTween.animate(_rotationController),
                    )
                  : SizedBox(
                      height: 48,
                      width: 48,
                    ),
              if (widget.showCheckBox)
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    _isChecked = value!;
                    widget.onCheck(_isChecked, widget.data, widget.index,
                        widget.parent, widget.listParent);
                  },
                ),
              if (widget.lazy && _showLoading)
                const SizedBox(
                  width: 12.0,
                  height: 12.0,
                  child: CircularProgressIndicator(strokeWidth: 1.0),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Image.network(
                  widget.data.icon,
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 12,
                    height: 12,
                    child: Image.asset(
                      ICONS.IC_PROFILE_ERROR_PNG,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    widget.data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (widget.showActions)
                TextButton(
                  onPressed: () {
                    widget.append(widget.data);
                    widget.onAppend(widget.data, widget.parent);
                  },
                  child: const Text('Add', style: TextStyle(fontSize: 12.0)),
                ),
              if (widget.showActions)
                TextButton(
                  onPressed: () {
                    widget.remove(widget.data);
                    widget.onRemove(widget.data, widget.parent);
                  },
                  child: const Text('Remove', style: TextStyle(fontSize: 12.0)),
                ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: _rotationController,
          child: Padding(
            padding: EdgeInsets.only(left: widget.offsetLeft),
            child: TreeNodesWidget(
              parent: widget.data,
              remove: widget.remove,
              append: widget.append,
              icon: widget.icon,
              lazy: widget.lazy,
              load: widget.load,
              offsetLeft: widget.offsetLeft,
              showCheckBox: widget.showCheckBox,
              showActions: widget.showActions,
              onTap: widget.onTap,
              onCheck: widget.onCheck,
              onExpand: widget.onExpand,
              onLoad: widget.onLoad,
              onCollapse: widget.onCollapse,
              onRemove: widget.onRemove,
              onAppend: widget.onAppend,
              list: _listChild,
              listParent: widget.listParent,
            ),
          ),
        ),
      ],
    );
  }
}

class TreeNodesWidget extends StatefulWidget {
  final List<TreeNodeData> list;

  final TreeNodeData parent;
  final List<TreeNodeData> listParent;

  final bool lazy;
  final Widget icon;
  final bool showCheckBox;
  final bool showActions;
  final double offsetLeft;

  final Function(TreeNodeData node, int index) onTap;
  final void Function(bool checked, TreeNodeData node, int index,
      TreeNodeData p, List<TreeNodeData> lp) onCheck;

  final void Function(TreeNodeData node) onExpand;
  final void Function(TreeNodeData node) onCollapse;

  final Future Function(TreeNodeData node) load;
  final void Function(TreeNodeData node) onLoad;

  final void Function(TreeNodeData node) remove;
  final void Function(TreeNodeData node, TreeNodeData parent) onRemove;

  final void Function(TreeNodeData node) append;
  final void Function(TreeNodeData node, TreeNodeData parent) onAppend;

  const TreeNodesWidget({
    Key? key,
    required this.parent,
    required this.offsetLeft,
    required this.showCheckBox,
    required this.showActions,
    required this.icon,
    required this.lazy,
    required this.load,
    required this.append,
    required this.remove,
    required this.onTap,
    required this.onCheck,
    required this.onLoad,
    required this.onExpand,
    required this.onAppend,
    required this.onRemove,
    required this.onCollapse,
    required this.list,
    required this.listParent,
  }) : super(key: key);

  @override
  State<TreeNodesWidget> createState() => _TreeNodesWidgetState();
}

class _TreeNodesWidgetState extends State<TreeNodesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.list.length, (int index) {
        return TreeNode(
          data: widget.list[index],
          parent: widget.parent,
          remove: widget.remove,
          append: widget.append,
          icon: widget.icon,
          lazy: widget.lazy,
          load: widget.load,
          offsetLeft: widget.offsetLeft,
          showCheckBox: widget.showCheckBox,
          showActions: widget.showActions,
          onTap: widget.onTap,
          onCheck: widget.onCheck,
          onExpand: widget.onExpand,
          onLoad: widget.onLoad,
          onCollapse: widget.onCollapse,
          onRemove: widget.onRemove,
          onAppend: widget.onAppend,
          index: index,
          listParent: widget.listParent,
        );
      }),
    );
  }
}
