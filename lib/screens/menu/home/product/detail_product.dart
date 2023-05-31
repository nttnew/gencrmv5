import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  String id = Get.arguments[1];
  String title = Get.arguments[0];
  List<ModuleThaoTac> list = [];

  @override
  void deactivate() {
    DetailProductBloc.of(context).add(ReloadProductEvent());
    super.deactivate();
  }

  @override
  void initState() {
    getThaoTac();
    DetailProductBloc.of(context).add(InitGetDetailProductEvent(id));
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.PRODUCT,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, PRODUCT_TYPE);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () async {
              DetailProductBloc.of(context).add(DeleteProductEvent(id));
            },
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(title),
      body: BlocListener<DetailProductBloc, DetailProductState>(
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: "Xoá thành công",
              onTap1: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, ROUTE_NAMES.PRODUCT, ModalRoute.withName('/'),
                    arguments: title);
              },
            );
          } else if (state is ErrorDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: state.msg,
              textButton1: "Quay lại",
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                DetailProductBloc.of(context)
                    .add(InitGetDetailProductEvent(id));
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ButtonThaoTac(onTap: () {
                  showThaoTac(context, list);
                }),
              ),
              BlocBuilder<DetailProductBloc, DetailProductState>(
                  builder: (context, state) {
                if (state is UpdateGetDetailProductState)
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          (state.productInfo?.data ?? []).length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: AppValue.heights * 0.04,
                                  ),
                                  WidgetText(
                                    title:
                                        (state.productInfo?.data ?? [])[index]
                                                .groupName ??
                                            '',
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        color: HexColor("#263238"),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: AppValue.heights * 0.02,
                                  ),
                                  Column(
                                    children: List.generate(
                                        (state.productInfo?.data?[index].data ??
                                                [])
                                            .length,
                                        (index1) => state
                                                        .productInfo
                                                        ?.data?[index]
                                                        .data?[index1]
                                                        .valueField !=
                                                    null &&
                                                state
                                                        .productInfo
                                                        ?.data?[index]
                                                        .data?[index1]
                                                        .valueField !=
                                                    ''
                                            ? Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      WidgetText(
                                                        title: state
                                                            .productInfo
                                                            ?.data?[index]
                                                            .data?[index1]
                                                            .labelField,
                                                        style: LabelStyle(),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: WidgetText(
                                                            title: state
                                                                .productInfo
                                                                ?.data?[index]
                                                                .data?[index1]
                                                                .valueField,
                                                            textAlign:
                                                                TextAlign.right,
                                                            style:
                                                                ValueStyle()),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        AppValue.heights * 0.02,
                                                  ),
                                                ],
                                              )
                                            : SizedBox()),
                                  ),
                                  LineHorizontal(),
                                ],
                              )),
                    ),
                  );
                else
                  return SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle ValueStyle([String? color]) => TextStyle(
      fontFamily: "Quicksand",
      color: color == null ? HexColor("#263238") : HexColor(color),
      fontWeight: FontWeight.w700,
      fontSize: 14);

  TextStyle LabelStyle() => TextStyle(
      fontFamily: "Quicksand",
      color: COLORS.GREY,
      fontWeight: FontWeight.w600,
      fontSize: 14);
}
