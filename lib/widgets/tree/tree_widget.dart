import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import '../../bloc/manager_filter/manager_bloc.dart';
import '../../src/color.dart';
import '../../src/styles.dart';
import 'tree_view.dart';
import '../../l10n/key_text.dart';

void showManagerFilter(BuildContext context, ManagerBloc bloc,
        Function(String ids) funFilter) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      builder: (context) => TreeWidget(
        bloc: bloc,
        funFilter: funFilter,
      ),
    );

class TreeWidget extends StatefulWidget {
  TreeWidget({
    Key? key,
    required this.bloc,
    required this.funFilter,
  }) : super(key: key);
  final ManagerBloc bloc;
  final Function(String ids) funFilter;

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  bool isShow = false;
  bool isCheck = true;

  List<TreeNodeData> _setTreeData(
    TreeNodeData node,
    List<TreeNodeData> result,
    bool isCheck, {
    TreeNodeData? p,
    List<TreeNodeData>? listParent,
    bool isTree = false,
    bool isParent = false,
  }) {
    for (int i = 0; i < result.length; i++) {
      if (isTree) {
        result[i].checked = isCheck;
        if (result[i].children.isNotEmpty) {
          _setTreeData(node, result[i].children, isCheck, isTree: true);
        }
      } else if (isParent) {
        /// isParent
      } else {
        if (node == result[i]) {
          result[i].checked = isCheck;
          if (result[i].children.isNotEmpty) {
            _setTreeData(node, result[i].children, isCheck, isTree: true);
          }
        } else {
          _setTreeData(
            node,
            result[i].children,
            isCheck,
            p: p,
            listParent: listParent,
          );
        }
      }
    }
    return result;
  }

  List<TreeNodeData> _setTreeExpand(
    TreeNodeData node,
    List<TreeNodeData> result,
    bool isExpand,
  ) {
    for (int i = 0; i < result.length; i++) {
      if (node == result[i]) {
        result[i].expaned = isExpand;
      } else {
        _setTreeExpand(
          node,
          result[i].children,
          isExpand,
        );
      }
    }
    return result;
  }

  @override
  void initState() {
    widget.bloc.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TreeNodeData>?>(
        stream: widget.bloc.managerTrees,
        builder: (context, snapshot) {
          final list = snapshot.data;
          if (list?.isNotEmpty ?? false) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetText(
                          title: getT(KeyT.user_manager),
                          style: AppStyle.DEFAULT_TITLE_APPBAR,
                        ),
                        GestureDetector(
                          onTap: () {
                            isCheck = !isCheck;
                            widget.bloc.resetData(isCheck);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: COLORS.RED.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: WidgetText(
                              title: getT(KeyT.all),
                              style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TreeView(
                        data: list ?? [],
                        onTap: (data, index) {
                          widget.bloc.managerTrees.add(_setTreeExpand(
                            data,
                            list ?? [],
                            !data.expaned,
                          ));
                        },
                        onCheck: (isCheck, data, index, p, lp) {
                          widget.bloc.managerTrees.add(_setTreeData(
                            data,
                            list ?? [],
                            isCheck,
                            p: p,
                            listParent: lp,
                          ));
                        },
                        showCheckBox: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ButtonCustom(
                            paddingAll: 12,
                            backgroundColor: COLORS.GREY.withOpacity(0.5),
                            marginHorizontal: 0,
                            title: getT(KeyT.close),
                            onTap: () => Get.back(),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ButtonCustom(
                            paddingAll: 12,
                            marginHorizontal: 0,
                            title: getT(KeyT.find),
                            onTap: () {
                              widget.bloc.save();
                              widget.funFilter(widget.bloc.ids);
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        });
  }
}
