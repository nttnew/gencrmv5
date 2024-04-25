import 'package:flutter/foundation.dart' as Foundation;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../src/models/model_generator/add_customer.dart';
import '../../../../../widgets/widget_text.dart';
import '../../../../api_resfull/dio_provider.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/model_item_add.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/listview/list_load_infinity.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/search_base.dart';

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
      var headers = {
        'Authorization': shareLocal.getString(PreferencesKey.TOKEN),
      };
      var dio = Dio();
      dio
        ..options.connectTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
        ..options.receiveTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds;
      if (Foundation.kDebugMode) {
        dio.interceptors.add(dioLogger());
      }
      var response = await dio.request(
        '${widget.data.field_parent?.field_url}?${widget.data.field_parent?.field_keyparam}=$id',
        options: Options(
          method: 'GET',
          headers: headers,
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
                  _onChangeMain(
                      res.first.first, _resultIndexTwoForList(element));
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
      var headers = {
        'Authorization': shareLocal.getString(PreferencesKey.TOKEN),
      };
      var dio = Dio();
      dio
        ..options.connectTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
        ..options.receiveTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds;
      if (Foundation.kDebugMode) {
        dio.interceptors.add(dioLogger());
      }
      var response = await dio.request(
        '${widget.data.field_search?.field_url}',
        options: Options(
          method: 'GET',
          headers: headers,
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
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: AppStyle.DEFAULT_14W600,
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: COLORS.RED,
                        ),
                      )
                    : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          StreamBuilder<List<List<dynamic>>?>(
              stream: _listSelectStream,
              builder: (context, snapshot) {
                final List<List<dynamic>>? listData = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    if (!isReadOnly)
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          builder: (BuildContext context) {
                            return widget.data.field_search != null
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
                                  );
                          });
                  },
                  child: Container(
                    width: double.infinity,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isReadOnly ? COLORS.LIGHT_GREY : COLORS.WHITE,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: COLORS.ffBEB4B4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 10,
                          right: 10,
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
                                      return WidgetText(
                                        title: listSnap.length > 1
                                            ? listSnap[1]
                                            : '',
                                        maxLine: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyle.DEFAULT_14_BOLD,
                                      );
                                    }),
                              ),
                              Container(
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
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
  String txtSearch = '';
  List<List<dynamic>> listAdd = [];

  Future<dynamic> getList({
    String? txt,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      LoadingApi().pushLoading();
      var headers = {
        'Authorization': shareLocal.getString(PreferencesKey.TOKEN),
      };
      var dio = Dio();
      dio
        ..options.connectTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
        ..options.receiveTimeout =
            Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds;
      if (Foundation.kDebugMode) {
        dio.interceptors.add(dioLogger());
      }
      var response = await dio.request(
        '${widget.data.field_search?.field_url}?${widget.data.field_search?.field_keyparam}=$page&'
        '${widget.data.field_search?.keysearch}=$txtSearch',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final List<dynamic> dataRes = response.data['data'] as List<dynamic>;
          final List<List<dynamic>> res =
              dataRes.map((e) => e as List<dynamic>).toList();
          LoadingApi().popLoading();
          return res;
        } else {
          LoadingApi().popLoading();
          return '';
        }
      } else {
        LoadingApi().popLoading();
        return response.data['msg'].toString();
      }
    } catch (e) {
      LoadingApi().popLoading();
      return getT(KeyT.an_error_occurred);
    }
  }

  _initController() async {
    if (widget.data.field_special == SPECIAL_KH) {
      listAdd = [
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
      listAdd = [
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
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              boxShadow: [
                BoxShadow(
                  color: COLORS.BLACK.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  onChange: (String v) {
                    txtSearch = v.trim();
                    _loadMoreController.reloadData();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ViewLoadMoreBase(
              widgetLoad: widgetLoading(),
              noDataWidget: null,
              functionInit: (page, isInit) {
                return getList(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                if (listAdd.length > 0 && index == 0) {
                  return Column(
                    children: [
                      ...listAdd
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                widget.onChange(e);
                              },
                              child: _itemList(e),
                            ),
                          )
                          .toList(),
                      GestureDetector(
                        onTap: () {
                          widget.onChange(data);
                        },
                        child: _itemList(data),
                      ),
                    ],
                  );
                }
                return GestureDetector(
                  onTap: () {
                    widget.onChange(data);
                  },
                  child: _itemList(data),
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
  List<List<dynamic>> listData = [];
  List<List<dynamic>> listAdd = [];

  void searchLocal(
    String name,
  ) {
    List<List<dynamic>> list = [];
    widget.listData.forEach((element) {
      if (element[1].toLowerCase().contains(name)) {
        list.add(element);
      }
    });
    listData = list;
  }

  @override
  void initState() {
    listData = widget.listData;
    if (widget.data.field_special == SPECIAL_KH) {
      listAdd = [
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
      listAdd = [
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
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              boxShadow: [
                BoxShadow(
                  color: COLORS.BLACK.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
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
            child: listData.length < 1
                ? ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    children: listAdd
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              widget.onChange(e);
                            },
                            child: _itemList(e),
                          ),
                        )
                        .toList(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    shrinkWrap: true,
                    itemCount: listData.length,
                    itemBuilder: (context, i) {
                      if (i == 0 && listAdd.length > 0) {
                        return Column(
                          children: [
                            ...listAdd
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      widget.onChange(e);
                                    },
                                    child: _itemList(e),
                                  ),
                                )
                                .toList(),
                            GestureDetector(
                              onTap: () {
                                widget.onChange(listData[i]);
                              },
                              child: _itemList(listData[i]),
                            ),
                          ],
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          widget.onChange(listData[i]);
                        },
                        child: _itemList(listData[i]),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

_itemList(dynamic data) {
  return Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 16,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      color: COLORS.WHITE,
      borderRadius: BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: COLORS.BLACK.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Text(
      data[1].toString() != 'null' && data[1].toString() != ''
          ? data[1].toString()
          : getT(KeyT.not_yet),
      style: AppStyle.DEFAULT_16_BOLD.copyWith(
        color: _getColor(
          data[0].toString(),
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
