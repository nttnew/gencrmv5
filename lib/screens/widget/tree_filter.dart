import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../src/app_const.dart';
import '../../../src/src_index.dart';
import '../../../widgets/tree/tree_node_model.dart';

class TreeFilter extends StatelessWidget {
  const TreeFilter({
    Key? key,
    required this.treeStream,
    required this.onTap,
  }) : super(key: key);
  final BehaviorSubject<List<TreeNodeData>> treeStream;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TreeNodeData>>(
      stream: treeStream,
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false)
          return Padding(
            padding: const EdgeInsets.only(
              left: 6.0,
            ),
            child: GestureDetector(
              onTap: () {
                onTap();
              },
              child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: COLORS.GREY_400,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        6,
                      ),
                    ),
                  ),
                  child: itemSearchFilterTree()),
            ),
          );
        return SizedBox();
      },
    );
  }
}
