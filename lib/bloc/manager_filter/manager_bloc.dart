import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/tree/tree_node_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';

part 'manager_event.dart';
part 'manager_state.dart';

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  final UserRepository userRepository;

  Set<TreeNodeData> saveDataFilter = {};
  BehaviorSubject<List<TreeNodeData>> managerTrees = BehaviorSubject.seeded([]);
  String ids = '';

  ManagerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetManager());

  @override
  Stream<ManagerState> mapEventToState(ManagerEvent event) async* {}

  Future<void> getManager({required String module}) async {
    try {
      final result = await userRepository.getListManagerFilter(
          module: getURLModule(module));
      List<TreeNodeData> list = [];
      for (final value in result) {
        list.add(TreeNodeData(
          title: value.title,
          expaned: value.expaned,
          checked: value.checked,
          children: value.children,
          id: value.id,
          icon: value.icon,
        ));
      }
      managerTrees.add(result);
    } catch (e) {
      throw e;
    }
  }

  List<TreeNodeData> setDataSave(
      List<TreeNodeData> list, List<TreeNodeData> listSave) {
    for (final value in listSave) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == value.id) {
          list[i].checked = value.checked;
          list[i].expaned = value.expaned;
        } else {
          setDataSave(list[i].children, listSave);
        }
      }
    }
    return list;
  }

  List<TreeNodeData> _setTreeData(
    List<TreeNodeData> result,
    TreeNodeData node,
  ) {
    for (int i = 0; i < result.length; i++) {
      if (node == result[i]) {
        result[i].checked = true;
      } else {
        _setTreeData(
          result[i].children,
          node,
        );
      }
    }
    return result;
  }

  void initData() {
    managerTrees.add(resetDataChecked(managerTrees.value, true));
    if (saveDataFilter.isNotEmpty) {
      managerTrees.add(resetDataChecked(managerTrees.value, false));
      for (final value in saveDataFilter) {
        managerTrees.add(_setTreeData(managerTrees.value, value));
      }
    }
  }

  void resetData(bool isCheck) {
    managerTrees.add(resetDataChecked(managerTrees.value, isCheck));
  }

  List<TreeNodeData> resetDataChecked(
    List<TreeNodeData> list,
    bool checked,
  ) {
    return list.map((e) {
      e.checked = checked;
      resetDataChecked(
        e.children,
        checked,
      );
      return e;
    }).toList();
  }

  void save() {
    ids = '';
    saveDataFilter = {};
    _getDataSave(managerTrees.value);
    print(saveDataFilter);
  }

  _getDataSave(List<TreeNodeData> list) {
    for (final value in list) {
      if (value.checked) {
        saveDataFilter.add(value);

        if (value.id.toString().contains('u')) {
          //id minus u
          final id = value.id.substring(1, value.id.length);
          if (ids == '') {
            ids += '${id}';
          } else {
            ids += ',${id}';
          }
        }
        _getDataSave(value.children);
      } else {
        _getDataSave(value.children);
      }
    }
  }

  static ManagerBloc of(BuildContext context) =>
      BlocProvider.of<ManagerBloc>(context);
}
