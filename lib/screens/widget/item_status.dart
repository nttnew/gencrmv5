import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/showToastM.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/dio_provider.dart';
import '../../l10n/key_text.dart';
import '../../src/models/model_generator/detail_customer.dart';
import '../../src/src_index.dart';
import '../../widgets/widget_text.dart';
import '../main/widget/select_body.dart';

class ItemStatus extends StatefulWidget {
  const ItemStatus({
    Key? key,
    required this.item,
  }) : super(key: key);
  final InfoItem? item;
  @override
  State<ItemStatus> createState() => _ItemStatusState();
}

class _ItemStatusState extends State<ItemStatus> {
  List<dynamic> _itemInit = [];
  BehaviorSubject<bool> _isSuccess = BehaviorSubject.seeded(false);
  @override
  void initState() {
    _itemInit = [
      widget.item?.id ?? '',
      widget.item?.value_field ?? '',
      widget.item?.color ?? '#000000',
    ];
    _isSuccess.listen((value) {
      if (value) setState(() {});
    });
    super.initState();
  }

  _changeStatus(ApiUpdateModel obj) async {
    var data =
        json.encode(obj.params).replaceAll('{value}', _itemInit.firstOrNull);
    var dio = DioProvider.dio;
    var response = await dio.request(
      obj.link.toString(),
      options: Options(
        method: 'POST',
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      _isSuccess.add(true);
      showToastM(
        context,
        title: response.data['msg'],
      );
    } else {
      _isSuccess.add(false);
      showToastM(context, title: response.data['msg']);
    }
  }

  @override
  void dispose() {
    _isSuccess.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showModalSelect(
          context,
          getT(KeyT.update) +
              ' ${(widget.item?.label_field ?? '').toLowerCase()}',
          widget.item?.options
                  ?.map((obj) => [obj.id, obj.name, obj.color])
                  .toList() ??
              [],
          init: _itemInit[1].toString(),
          (data) async {
            _itemInit = data ?? _itemInit;
            final _obj = widget.item?.apiUpdate;
            if (_obj != null) _changeStatus(_obj);
            Get.back();
          },
        );
      },
      child: WidgetText(
        title: _itemInit[1].replaceAll(r'\n', '\n'),
        textAlign: TextAlign.right,
        style: AppStyle.DEFAULT_14.copyWith(
          decoration: TextDecoration.underline,
          color: HexColor(_itemInit[2]),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
