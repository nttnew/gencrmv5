import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/extensionss/common_ext.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../widgets/widget_text.dart';
import '../../../../api_resfull/dio_provider.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/model_item_add.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/search_base.dart';
import '../../widget/widget_label.dart';

class InputDropdownBase extends StatefulWidget {
  InputDropdownBase({
    Key? key,
    required this.data,
    required this.onChange,
    required this.addData,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final List<ModelItemAdd> addData;
  final Function(dynamic, bool?) onChange;

  @override
  State<InputDropdownBase> createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdownBase> {
  BehaviorSubject<List<dynamic>> _selectStream =
      BehaviorSubject.seeded(['', '']);
  BehaviorSubject<List<List<dynamic>>?> _listSelectStream = BehaviorSubject();
  dynamic _idDF = '';

  void getId() {
    final List<ModelItemAdd> dataSelect = widget.addData;
    dataSelect.forEach((element) {
      element.data.forEach((value) {
        if (value.label == widget.data.field_parent?.field_value) {
          if (value.value != null &&
              value.value != '' &&
              _idDF != value.value) {
            _selectStream.add(['', '']);
            _onChangeMain('', null); //reset select
            _idDF = value.value;
            getDataApi(value.value.toString());
          }
        }
      });
    });
  }

  Future<void> getDataApi(String id) async {
    try {
      var dio = DioProvider.dio;
      var response = await dio.request(
        '${widget.data.field_parent?.field_url}?${widget.data.field_parent?.field_keyparam}=$id',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final List<dynamic> dataRes = response.data['data'] as List<dynamic>;
          final List<List<dynamic>> res =
              dataRes.map((e) => e as List<dynamic>).toList();
          final List<List<dynamic>> fieldSetValueDatasource =
              widget.data.field_set_value_datasource ?? [];
          if (res.length > 0 && fieldSetValueDatasource.length > 0) {
            res.forEach((element) {
              if (fieldSetValueDatasource.first.length > 0) {
                if (element.first == fieldSetValueDatasource.first.first) {
                  _selectStream.add(element);
                  _onChangeMain(element.first, _resultIndexTwoForList(element));
                }
              }
            });
          }

          if (widget.data.field_name == 'mau_sac') {
            //case dac biet
            if (res.length > 0) _selectStream.add(res.first);
            _listSelectStream.add(widget.data.field_datasource);
          } else {
            _listSelectStream.add(res);
          }
        } else {
          if (widget.data.field_name == 'mau_sac') {
            //case dac biet
            _listSelectStream.add(widget.data.field_datasource);
          } else {
            _listSelectStream.add(null);
          }
        }
      }
    } catch (e) {
      throw e;
    }
  }

  void getList() async {
    try {
      var dio = DioProvider.dio;
      var response = await dio.request(
        '${widget.data.field_search?.field_url}',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final List<dynamic> dataRes = response.data['data'] as List<dynamic>;
          final List<List<dynamic>> res =
              dataRes.map((e) => e as List<dynamic>).toList();
          _listSelectStream.add(res);
        } else {
          _listSelectStream.add([]);
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    final CustomerIndividualItemData data = widget.data;
    if (data.field_datasource != null) {
      _listSelectStream.add(data.field_datasource);
    }

    if (data.field_set_value_datasource != null &&
        (data.field_set_value_datasource?.length ?? 0) > 0) {
      _selectStream.add(data.field_set_value_datasource?.first ?? ['', '']);
      _onChangeMain(
        data.field_set_value_datasource?.first.first,
        _resultIndexTwoForList(data.field_set_value_datasource?.first ?? []),
      );
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputDropdownBase oldWidget) {
    if (widget.data.field_parent != null) getId();
    super.didUpdateWidget(oldWidget);
  }

  _onChangeMain(id, bool? isCK) {
    closeKey();
    widget.onChange(id, isCK);
  }

  @override
  void dispose() {
    _selectStream.close();
    _listSelectStream.close();
    super.dispose();
  }

  _onDropDown(List<dynamic> v) async {
    if (v.length > 1) if (v.first == ADD_NEW_CAR ||
        v.first == CA_NHAN ||
        v.first == TO_CHUC) {
      List<dynamic>? result = [];

      if (v.first == ADD_NEW_CAR) {
        result = await AppNavigator.navigateForm(
          title: v[1].toString(),
          type: PRODUCT_CUSTOMER_TYPE,
          isGetData: true,
          id: int.tryParse(_idDF),
        );
      } else if (v.first == CA_NHAN) {
        result = await AppNavigator.navigateForm(
          title: v[1].toString(),
          type: ADD_CUSTOMER,
          isGetData: true,
        );
      } else if (v.first == TO_CHUC) {
        result = await AppNavigator.navigateForm(
          title: v[1].toString(),
          type: ADD_CUSTOMER_OR,
          isGetData: true,
        );
      }

      if (result != null && result.isNotEmpty) {
        if (v.first == ADD_NEW_CAR) {
          if (result.length > 1) {
            _selectStream.add(result.first);
            _onChangeMain(
                result.first[0], _resultIndexTwoForList(result.first));
            Navigator.pop(context);
            getDataApi(result[1].toString());
          }
        } else {
          _selectStream.add(result);
          _onChangeMain(result.first, _resultIndexTwoForList(result));
          Navigator.pop(context);
          getList();
        }
      }
    } else {
      _selectStream.add(v);
      _onChangeMain(v.first, _resultIndexTwoForList(v));
      Navigator.pop(context);
    }
  }

  bool? _resultIndexTwoForList(List<dynamic> result) {
    //check bang 'ck' == true hinh_thuc_thanh_toan
    return result.length > 2 ? result[2] == 'CK' : null;
  }

  @override
  Widget build(BuildContext context) {
    bool isReadOnly = widget.data.field_read_only.toString() == '1';
    return Container(
      margin: marginBottomFrom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          StreamBuilder<List<List<dynamic>>?>(
              stream: _listSelectStream,
              builder: (context, snapshot) {
                final List<List<dynamic>>? listData = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    if (!isReadOnly)
                      showBottomGenCRM(
                        child: widget.data.field_search != null
                            ? DropDownSearchApi(
                                data: widget.data,
                                onChange: (List<dynamic> v) {
                                  _onDropDown(v);
                                },
                                listData: listData,
                              )
                            : DropDownWidget(
                                data: widget.data,
                                onChange: (List<dynamic> v) {
                                  _onDropDown(v);
                                },
                                listData: listData ?? [],
                              ),
                      );
                  },
                  child: Container(
                    padding: paddingBaseForm,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: COLORS.WHITE,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: COLORS.COLOR_GRAY,
                        width: isReadOnly ? 0.3 : 1,
                      ),
                    ),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: StreamBuilder<List<dynamic>>(
                                stream: _selectStream,
                                builder: (context, snapshot) {
                                  final List<dynamic> listSnap =
                                      snapshot.data ?? [];
                                  return listSnap.length > 1
                                      ? listSnap[1] != ''
                                          ? WidgetText(
                                              title:
                                                  listSnap[1].toString().trim(),
                                              maxLine: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyle.DEFAULT_14_BOLD
                                                  .copyWith(
                                                color: isReadOnly
                                                    ? COLORS.GREY
                                                    : null,
                                              ),
                                            )
                                          : WidgetLabel(widget.data)
                                      : WidgetLabel(widget.data);
                                }),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: isReadOnly ? COLORS.COLOR_GRAY : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          StreamBuilder<List<dynamic>>(
              stream: _selectStream,
              builder: (context, snapshot) {
                final List<dynamic> listSnap = snapshot.data ?? [];
                return listSnap.length > 1
                    ? listSnap[1] != ''
                        ? WidgetLabelPo(data: widget.data)
                        : SizedBox.shrink()
                    : SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}

class DropDownSearchApi extends StatefulWidget {
  const DropDownSearchApi({
    Key? key,
    required this.data,
    required this.onChange,
    this.listData,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function(List<dynamic>) onChange;
  final List<List<dynamic>>? listData;

  @override
  State<DropDownSearchApi> createState() => _DropDownSearchApiState();
}

class _DropDownSearchApiState extends State<DropDownSearchApi> {
  LoadMoreController _loadMoreController = LoadMoreController();
  String _txtSearch = '';
  List<List<dynamic>> _listAdd = [];

  Future<dynamic> getList({
    String? txt,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      var dio = DioProvider.dio;
      var response = await dio.request(
        '${widget.data.field_search?.field_url}?${widget.data.field_search?.field_keyparam}=$page&'
        '${widget.data.field_search?.keysearch}=$_txtSearch',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final List<dynamic> dataRes = response.data['data'] as List<dynamic>;
          final List<List<dynamic>> res =
              dataRes.map((e) => e as List<dynamic>).toList();
          return res;
        } else {
          return [];
        }
      } else {
        return response.data['msg'].toString();
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  _initController() async {
    if (widget.data.field_special == SPECIAL_KH) {
      _listAdd = [
        [
          CA_NHAN,
          '${getT(KeyT.add)}'
              ' ${widget.data.field_label?.toLowerCase()} '
              '${getT(KeyT.individual)}'
        ],
        [
          TO_CHUC,
          '${getT(KeyT.add)}'
              ' ${widget.data.field_label?.toLowerCase()} '
              '${getT(KeyT.organization)}'
        ]
      ];
    } else if (widget.data.field_special == SPECIAL_SPKH) {
      _listAdd = [
        [
          ADD_NEW_CAR,
          '${getT(KeyT.add)} ${widget.data.field_label?.toLowerCase()}',
          '',
          ''
        ]
      ];
    }
    _loadMoreController
        .initData(widget.listData ?? widget.data.field_datasource ?? []);
    _loadMoreController.isLoadMore = true;
  }

  @override
  void initState() {
    _loadMoreController.isSet = true;
    _initController();
    super.initState();
  }

  @override
  void dispose() {
    _loadMoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              boxShadow: boxShadowVip,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: WidgetText(
                    title: getT(KeyT.select) +
                        ' ' +
                        '${widget.data.field_label?.toLowerCase()}',
                    style: AppStyle.DEFAULT_20_BOLD,
                    textAlign: TextAlign.center,
                  ),
                ),
                SearchBase(
                  hint:
                      '${getT(KeyT.find)} ${widget.data.field_label?.toLowerCase()}',
                  leadIcon: itemSearch(),
                  onChange: (String v) {
                    _txtSearch = v.trim();
                    _loadMoreController.reloadData();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ViewLoadMoreBase(
              paddingList: 6,
              widgetLoad: widgetLoading(),
              noDataWidget: null,
              functionInit: (page, isInit) {
                return getList(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                if (_listAdd.length > 0 && index == 0) {
                  return Column(
                    children: [
                      ..._listAdd
                          .map(
                            (e) => _itemList(
                              e,
                              () {
                                widget.onChange(e);
                              },
                            ),
                          )
                          .toList(),
                      _itemList(
                        data,
                        () {
                          widget.onChange(data);
                        },
                      ),
                    ],
                  );
                }
                return _itemList(
                  data,
                  () {
                    widget.onChange(data);
                  },
                );
              },
              controller: _loadMoreController,
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    Key? key,
    required this.data,
    required this.onChange,
    required this.listData,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final List<List<dynamic>> listData;
  final Function(List<dynamic>) onChange;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  List<List<dynamic>> _listData = [];
  List<List<dynamic>> _listAdd = [];

  void searchLocal(
    String name,
  ) {
    List<List<dynamic>> list = [];
    widget.listData.forEach((element) {
      if (element[1].toLowerCase().contains(name)) {
        list.add(element);
      }
    });
    _listData = list;
    setState(() {});
  }

  @override
  void initState() {
    _listData = widget.listData;
    if (widget.data.field_special == SPECIAL_KH) {
      _listAdd = [
        [
          CA_NHAN,
          '${getT(KeyT.add)}'
              ' ${widget.data.field_label?.toLowerCase()} '
              '${getT(KeyT.individual)}'
        ],
        [
          TO_CHUC,
          '${getT(KeyT.add)}'
              ' ${widget.data.field_label?.toLowerCase()} '
              '${getT(KeyT.organization)}'
        ]
      ];
    } else if (widget.data.field_special == SPECIAL_SPKH) {
      _listAdd = [
        [
          ADD_NEW_CAR,
          '${getT(KeyT.add)} ${widget.data.field_label?.toLowerCase()}',
          '',
          ''
        ]
      ];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              boxShadow: boxShadowVip,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: WidgetText(
                    title: getT(KeyT.select) +
                        ' ' +
                        '${widget.data.field_label?.toLowerCase()}',
                    style: AppStyle.DEFAULT_20_BOLD,
                    textAlign: TextAlign.center,
                  ),
                ),
                SearchBase(
                  hint:
                      '${getT(KeyT.find)} ${widget.data.field_label?.toLowerCase()}',
                  leadIcon: itemSearch(),
                  milliseconds: 0,
                  onChange: (String v) {
                    searchLocal(v);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _listData.isEmpty && _listAdd.isNotEmpty
                ? _buildListView(_listAdd)
                : _listAdd.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        shrinkWrap: true,
                        itemCount: _listData.length,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return Column(
                              children: [
                                ..._listAdd
                                    .map((e) => _buildGestureDetector(e))
                                    .toList(),
                                _buildGestureDetector(_listData[i]),
                              ],
                            );
                          }
                          return _buildGestureDetector(_listData[i]);
                        },
                      )
                    : _listData.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            shrinkWrap: true,
                            itemCount: _listData.length,
                            itemBuilder: (context, i) {
                              return _buildGestureDetector(_listData[i]);
                            },
                          )
                        : noData(),
          )
        ],
      ),
    );
  }

  Widget _buildListView(List<dynamic> list) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 6),
      children: list.map((e) => _buildGestureDetector(e)).toList(),
    );
  }

  Widget _buildGestureDetector(dynamic item) {
    return _itemList(
      item,
      () {
        widget.onChange(item);
      },
    );
  }
}

_itemList(
  dynamic data,
  Function onTap,
) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 16,
    ),
    width: double.infinity,
    child: InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          border: Border.all(
            color: COLORS.GREY_400,
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
        ),
        child: Text(
          data[1].toString() != 'null' && data[1].toString() != ''
              ? data[1].toString().trim()
              : getT(KeyT.not_yet),
          style: AppStyle.DEFAULT_16_BOLD.copyWith(
            color: _getColor(
              data[0].toString(),
            ),
          ),
        ),
      ),
    ),
  );
}

Color? _getColor(String name) {
  if (name == CA_NHAN || name == TO_CHUC || name == ADD_NEW_CAR) {
    return COLORS.TEXT_RED;
  }
  return null;
}
