import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/location.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/form_input/form_input.dart';
import '../../../../widgets/widget_text.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    Key? key,
    required this.data,
    required this.onSuccess,
    this.initData,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function onSuccess;
  final dynamic initData;

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
  Widget build(BuildContext context) {
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
                          fontFamily: "Quicksand",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
          GestureDetector(
            onTap: () async {
              if (widget.data.field_special != "none-edit") {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              final LocationModel? result = await showModalBottomSheet(
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SelectLocationBottomSheet(
                      init: initData,
                      title: widget.data.field_label ?? '',
                    );
                  });

              if (result != null) {
                initData = result;
                dataTitle = result.getTitle();
                widget.onSuccess(result.toJson());
                setState(() {});
              }
            },
            child: Container(
              width: double.infinity,
              color: widget.data.field_special == "none-edit"
                  ? COLORS.GREY_400
                  : COLORS.WHITE,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  border: Border.all(
                    color: COLORS.ffBEB4B4,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    10,
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: WidgetText(
                            title: dataTitle,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: COLORS.BLACK,
                            ),
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
            if (dataS != tinhThanh) {
              tinhThanh = dataS;
              quanHuyen = empty;
              phuongXa = empty;
              setState(() {});
            }
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
            if (quanHuyen != dataS) {
              quanHuyen = dataS;
              phuongXa = empty;
              setState(() {});
            }
          },
          validate: quanHuyen?[NAME],
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
            if (phuongXa != dataS) {
              phuongXa = dataS;
              setState(() {});
            }
          },
          validate: phuongXa?[NAME],
        ),
        AppValue.vSpaceMedium,
        AppValue.vSpaceMedium,
        ButtonThaoTac(
          onTap: () {
            if (tinhThanh?[NAME] == '') {
              tinhThanh = null;
            }
            if (quanHuyen?[NAME] == '') {
              quanHuyen = null;
            }
            if (phuongXa?[NAME] == '') {
              phuongXa = null;
            }
            setState(() {});
            if (phuongXa != null && quanHuyen != null && tinhThanh != null) {
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
    this.shinkWrap = false,
    this.code,
    required this.text,
    required this.title,
    required this.onSelect,
    this.isHide = false,
    this.isQuanHuyen = true,
    this.validate,
  }) : super(key: key);

  final bool shinkWrap;
  final String? code;
  final String text;
  final String title;
  final bool isHide;
  final bool isQuanHuyen;
  final String? validate;
  final Function(Map<String, dynamic>) onSelect;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != (data?[NAME] ?? widget.text))
          Padding(
            padding: EdgeInsets.only(
              left: widget.shinkWrap ? 0 : 16,
              right: widget.shinkWrap ? 0 : 16,
              bottom: 4,
            ),
            child: Text(
              title,
              style: AppStyle.APP_MEDIUM.copyWith(
                color: COLORS.GREY,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: widget.shinkWrap ? 0 : 16,
            right: widget.shinkWrap ? 0 : 16,
          ),
          child: InkWell(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (!isHide) {
                final result = await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  backgroundColor: COLORS.WHITE,
                  builder: (_) => ListLocation(
                    listData: listData,
                    title: widget.title,
                    text: widget.text,
                  ),
                );
                if (result != null) {
                  data = result;
                  widget.onSelect(result);
                  setState(() {});
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5,
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
        ),
        if (validate == null) ...[
          AppValue.hSpaceTiny,
          Padding(
            padding: EdgeInsets.only(
              left: widget.shinkWrap ? 0 : 16,
              right: widget.shinkWrap ? 0 : 16,
            ),
            child: Text(
              '${getT(KeyT.not_select).trim()} ${widget.title.toLowerCase()}',
              style: AppStyle.DEFAULT_14.apply(
                color: Colors.red,
              ),
            ),
          ),
        ]
      ],
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
            child: Text(
              widget.title,
              style: AppStyle.DEFAULT_18_BOLD,
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
