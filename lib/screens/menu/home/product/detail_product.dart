import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../bloc/product_module/product_module_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../models/product_model.dart';
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
  late final DetailProductBloc _bloc;

  @override
  void initState() {
    _bloc = DetailProductBloc(
        userRepository: DetailProductBloc.of(context).userRepository);
    _init();
    super.initState();
  }

  _init() {
    _bloc.add(InitGetDetailProductEvent(id));
  }

  getThaoTac(ProductModel? product) {
    list = [];
    list.add(ModuleThaoTac(
      title:
          '${AppLocalizations.of(Get.context!)?.add} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}',
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddContract(
          title:
              '${AppLocalizations.of(Get.context!)?.add} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}',
          product: (product?.id ?? '') != '' ? product : null,
        );
      },
    ));

    list.add(ModuleThaoTac(
      title: AppLocalizations.of(Get.context!)?.see_attachment ?? '',
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
      title: AppLocalizations.of(Get.context!)?.edit ?? '',
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, PRODUCT_TYPE, onRefresh: () {
          _bloc.add(InitGetDetailProductEvent(id));
          ProductModuleBloc.of(context).add(InitGetListProductModuleEvent());
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: AppLocalizations.of(Get.context!)?.delete ?? '',
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () async {
            _bloc.add(DeleteProductEvent(id));
          },
          content: AppLocalizations.of(Get.context!)
                  ?.are_you_sure_you_want_to_delete ??
              '',
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(title),
      body: BlocListener<DetailProductBloc, DetailProductState>(
        bloc: _bloc,
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: AppLocalizations.of(Get.context!)?.notification,
              content: AppLocalizations.of(Get.context!)?.delete_success ?? '',
              onTap1: () {
                ProductModuleBloc.of(context)
                    .add(InitGetListProductModuleEvent());
                Navigator.pushNamedAndRemoveUntil(
                    context, ROUTE_NAMES.PRODUCT, ModalRoute.withName('/'),
                    arguments: title);
              },
            );
          } else if (state is ErrorDeleteProductState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: AppLocalizations.of(Get.context!)?.notification,
              content: state.msg,
              textButton1: AppLocalizations.of(Get.context!)?.come_back ?? '',
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                _bloc.add(InitGetDetailProductEvent(id));
              },
            );
          }
        },
        child: Container(
          child: Stack(
            children: [
              BlocBuilder<DetailProductBloc, DetailProductState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is UpdateGetDetailProductState) {
                      getThaoTac(state.product);
                      return RefreshIndicator(
                        onRefresh: () async {
                          await _init();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  (state.productInfo?.data ?? []).length,
                                  (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: AppValue.heights * 0.04,
                                          ),
                                          WidgetText(
                                            title: (state.productInfo?.data ??
                                                        [])[index]
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
                                                (state.productInfo?.data?[index]
                                                            .data ??
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
                                                                    ?.data?[
                                                                        index]
                                                                    .data?[
                                                                        index1]
                                                                    .labelField,
                                                                style:
                                                                    LabelStyle(),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: WidgetText(
                                                                    title: state
                                                                        .productInfo
                                                                        ?.data?[
                                                                            index]
                                                                        .data?[
                                                                            index1]
                                                                        .valueField,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        ValueStyle()),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: AppValue
                                                                    .heights *
                                                                0.02,
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox()),
                                          ),
                                          LineHorizontal(),
                                        ],
                                      )),
                            ),
                          ),
                        ),
                      );
                    } else
                      return SizedBox();
                  }),
              Positioned(
                bottom: 0,
                right: 25,
                left: 25,
                child: ButtonThaoTac(onTap: () {
                  showThaoTac(context, list);
                }),
              ),
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
