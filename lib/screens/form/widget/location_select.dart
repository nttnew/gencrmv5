import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart' as APP_CONST;
import '../../../../src/location.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/form_input/form_input.dart';
import '../../../../widgets/widget_text.dart';
import '../../widget/widget_label.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    Key? key,
    required this.data,
    required this.onSuccess,
    this.initData,
    this.initText,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function onSuccess;
  final dynamic initData;
  final String? initText;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String dataTitle = '';
  LocationModel? initData;

  @override
  void initState() {
    if (widget.initData != '' && widget.initData != null) {
      initData = LocationModel.fromJson(jsonDecode(widget.initData));
      dataTitle = initData?.getTitle() ?? '';
      WidgetsBinding.instance.addPostFrameCallback((Duration value) {
        if (mounted) widget.onSuccess(initData?.toJson());
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LocationWidget oldWidget) {
    if (widget.initText != null) {
      dataTitle = widget.initText!;
      initData = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    bool isReadOnly = widget.data.field_special == 'none-edit';
    return Container(
      margin: marginBottomFrom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (!isReadOnly) {
                final LocationModel? result = await APP_CONST.showBottomGenCRM(
                  child: SelectLocationBottomSheet(
                    init: initData,
                    title: widget.data.field_label ?? '',
                  ),
                );

                if (result != null) {
                  initData = result;
                  dataTitle = result.getTitle();
                  widget.onSuccess(result.toJson());
                  setState(() {});
                }
              }
            },
            child: Container(
              padding: paddingBaseForm,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                border: Border.all(
                  color: COLORS.COLOR_GRAY,
                  width: isReadOnly ? 0.2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: dataTitle != ''
                        ? WidgetText(
                            title: dataTitle,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.DEFAULT_14_BOLD.copyWith(
                              color: isReadOnly ? COLORS.GREY : null,
                            ),
                          )
                        : WidgetLabel(widget.data),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                    color: isReadOnly ? COLORS.COLOR_GRAY : null,
                  )
                ],
              ),
            ),
          ),
          if (dataTitle != '') WidgetLabelPo(data: widget.data),
        ],
      ),
    );
  }
}

class SelectLocationBottomSheet extends StatefulWidget {
  const SelectLocationBottomSheet({
    Key? key,
    required this.title,
    this.init,
  }) : super(key: key);
  final String title;
  final LocationModel? init;
  @override
  State<SelectLocationBottomSheet> createState() =>
      _SelectLocationBottomSheetState();
}

class _SelectLocationBottomSheetState extends State<SelectLocationBottomSheet> {
  Map<String, dynamic>? tinhThanh = empty;
  Map<String, dynamic>? quanHuyen = empty;
  Map<String, dynamic>? phuongXa = empty;

  @override
  void initState() {
    if (widget.init != null) {
      tinhThanh = {
        NAME: widget.init?.tinhThanh,
        ID: widget.init?.tinhThanhId,
        CODE: widget.init?.tinhThanhCode,
      };
      quanHuyen = {
        NAME: widget.init?.quanHuyen,
        ID: widget.init?.quanHuyenId,
        CODE: widget.init?.quanHuyenCode,
      };
      phuongXa = {
        NAME: widget.init?.phuongXa,
        ID: widget.init?.phuongXaId,
        CODE: widget.init?.phuongXaCode,
      };
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(
            16,
          ),
          child: WidgetText(
            title: widget.title,
            style: AppStyle.DEFAULT_18_BOLD,
          ),
        ),
        SelectTypeLocation(
          title: getT(KeyT.PROVINCE_CITY),
          text: checkTitle(
            tinhThanh?[NAME],
            getT(KeyT.PROVINCE_CITY),
          ),
          onSelect: (dataS) {
            if (dataS != tinhThanh && dataS != null) {
              tinhThanh = dataS;
              quanHuyen = empty;
              phuongXa = empty;
            } else {
              tinhThanh = empty;
              quanHuyen = empty;
              phuongXa = empty;
            }
            setState(() {});
          },
          validate: tinhThanh?[NAME],
        ),
        AppValue.vSpaceSmall,
        SelectTypeLocation(
          title: getT(KeyT.DISTRICT),
          text: checkTitle(
            quanHuyen?[NAME],
            getT(KeyT.DISTRICT),
          ),
          code: tinhThanh?[CODE],
          isHide: tinhThanh == null || tinhThanh?[NAME] == '',
          onSelect: (dataS) {
            if (quanHuyen != dataS && dataS != null) {
              quanHuyen = dataS;
              phuongXa = empty;
            } else {
              quanHuyen = empty;
              phuongXa = empty;
            }
            setState(() {});
          },
          validate: '',
        ),
        AppValue.vSpaceSmall,
        SelectTypeLocation(
          isQuanHuyen: false,
          title: getT(KeyT.WARD_COMMUNE),
          code: quanHuyen?[CODE],
          text: checkTitle(
            phuongXa?[NAME],
            getT(KeyT.WARD_COMMUNE),
          ),
          isHide: quanHuyen == null || quanHuyen?[NAME] == '',
          onSelect: (dataS) {
            if (dataS != null) {
              phuongXa = dataS;
            } else {
              phuongXa = empty;
            }
            setState(() {});
          },
          validate: '',
        ),
        AppValue.vSpaceMedium,
        AppValue.vSpaceMedium,
        ButtonCustom(
          onTap: () {
            if (tinhThanh?[NAME] == '') {
              tinhThanh = null;
            }
            setState(() {});
            if (tinhThanh != null) {
              Navigator.of(context).pop(
                LocationModel(
                  tinhThanh: tinhThanh?[NAME],
                  tinhThanhId: tinhThanh?[ID],
                  tinhThanhCode: tinhThanh?[CODE],
                  quanHuyen: quanHuyen?[NAME],
                  quanHuyenId: quanHuyen?[ID],
                  quanHuyenCode: quanHuyen?[CODE],
                  phuongXa: phuongXa?[NAME],
                  phuongXaId: phuongXa?[ID],
                  phuongXaCode: phuongXa?[CODE],
                ),
              );
            }
          },
          title: getT(KeyT.select),
        ),
      ],
    );
  }
}

class SelectTypeLocation extends StatefulWidget {
  const SelectTypeLocation({
    Key? key,
    this.code,
    required this.text,
    required this.title,
    required this.onSelect,
    this.isHide = false,
    this.isQuanHuyen = true,
    this.validate,
  }) : super(key: key);

  final String? code;
  final String text;
  final String title;
  final bool isHide;
  final bool isQuanHuyen;
  final String? validate;
  final Function(Map<String, dynamic>?) onSelect;

  @override
  State<SelectTypeLocation> createState() => _SelectTypeLocationState();
}

class _SelectTypeLocationState extends State<SelectTypeLocation> {
  List<Map<String, dynamic>> listData = [];
  Map<String, dynamic>? data;
  bool isHide = false;
  String? validate;
  String title = '';

  @override
  void initState() {
    title = widget.title;
    initCode();
    super.initState();
  }

  initCode() {
    isHide = widget.isHide;
    validate = widget.validate;
    final String? code = widget.code;
    if (code == null) {
      listData = getTinhThanh();
    } else if (widget.isQuanHuyen) {
      listData = getQuanHuyen(code);
    } else {
      listData = getPhuongXa(code);
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant SelectTypeLocation oldWidget) {
    if (oldWidget.code != widget.code) {
      data = null;
    }
    if (oldWidget.isHide != widget.isHide ||
        oldWidget.code != widget.code ||
        oldWidget.validate != widget.validate) {
      initCode();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!isHide) {
                    final result = await APP_CONST.showBottomGenCRM(
                      child: ListLocation(
                        listData: listData,
                        title: widget.title,
                        text: widget.text,
                      ),
                    );
                    data = result;
                    widget.onSelect(result);
                    setState(() {});
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: paddingBaseForm,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        4,
                      ),
                    ),
                    border: Border.all(
                      color: _getColor(),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          !isHide ? (data?[NAME] ?? widget.text) : widget.text,
                          style: AppStyle.DEFAULT_14.copyWith(
                            color: _getColor(isText: true),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: _getColor(isText: true),
                      ),
                    ],
                  ),
                ),
              ),
              if (title != (data?[NAME] ?? widget.text))
                WidgetLabelPo(
                  data: CustomerIndividualItemData.two(
                    field_label: title,
                  ),
                ),
            ],
          ),
          if (validate == null) ...[
            AppValue.hSpaceTiny,
            Text(
              '${(getT(KeyT.not_select)).trim()} ${widget.title.toLowerCase()}',
              style: AppStyle.DEFAULT_14.apply(
                color: Colors.red,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Color _getColor({isText = false}) => !isHide
      ? isText
          ? COLORS.BLACK
          : COLORS.GREY_400
      : COLORS.ffBEB4B4;
}

class ListLocation extends StatefulWidget {
  final List<Map<String, dynamic>> listData;
  final String title;
  final String text;
  const ListLocation({
    Key? key,
    required this.listData,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  State<ListLocation> createState() => _ListLocationState();
}

class _ListLocationState extends State<ListLocation> {
  late final List<Map<String, dynamic>> listData;
  List<Map<String, dynamic>> listUi = [];

  @override
  void initState() {
    listData = widget.listData;
    listUi = widget.listData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppStyle.DEFAULT_18_BOLD,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: COLORS.PRIMARY_COLOR,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          4,
                        ),
                      ),
                    ),
                    child: Text(
                      getT(KeyT.unselect),
                      style: AppStyle.DEFAULT_14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FormInputBase(
                hint: '${getT(KeyT.search)} ${widget.title.toLowerCase()}',
                textInputAction: TextInputAction.search,
                onChange: (v) {
                  listUi = searchAddress(v.trim(), listData);
                  setState(() {});
                }),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: listUi.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(listUi[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: widget.text == listUi[index][NAME]
                            ? COLORS.PRIMARY_COLOR
                            : COLORS.WHITE,
                      ),
                      child: Text(
                        listUi[index][NAME],
                        style: AppStyle.DEFAULT_16_T,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
