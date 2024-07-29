import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/products_response.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../../src/src_index.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../bloc/product_module/product_module_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import '../../widget/information.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  String _id = Get.arguments ?? '';
  String _title = '';
  List<ModuleThaoTac> _list = [];
  late final DetailProductBloc _bloc;

  @override
  void initState() {
    _bloc = DetailProductBloc(
        userRepository: DetailProductBloc.of(context).userRepository);
    _init();
    super.initState();
  }

  _init() {
    _bloc.add(InitGetDetailProductEvent(_id));
  }

  _getThaoTac(ProductsRes? product) {
    _list = [];
    _list.add(ModuleThaoTac(
      title: '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}',
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          title:
              '${getT(KeyT.add)} ${ModuleMy.getNameModuleMy(ModuleMy.HOP_DONG)}',
          type: ADD_CONTRACT,
          product: (product?.productId ?? '') != '' ? product : null,
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_PNG,      isSvg: false,

      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id,
                  typeModule: Module.PRODUCT,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          type: PRODUCT_TYPE_EDIT,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _bloc.add(InitGetDetailProductEvent(_id));
            ProductModuleBloc.of(context).loadMoreController.reloadData();
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () async {
            _bloc.add(DeleteProductEvent(_id));
          },
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(_title),
      body: BlocListener<DetailProductBloc, DetailProductState>(
        bloc: _bloc,
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: getT(KeyT.delete_success),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back(result: true);
                ProductModuleBloc.of(context).loadMoreController.reloadData();
              },
            );
          } else if (state is ErrorDeleteProductState) {
            Loading().popLoading();
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
              textButton1: getT(KeyT.come_back),
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
                _bloc.add(InitGetDetailProductEvent(_id));
              },
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<DetailProductBloc, DetailProductState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is UpdateGetDetailProductState) {
                      _getThaoTac(state.product);
                      _title = checkTitle(
                        state.productInfo?.data ?? [],
                        '111',// 111 là id của tên sản phẩm
                      );
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return RefreshIndicator(
                        color: getBackgroundWithIsCar(),
                        onRefresh: () async {
                          await _init();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              top: 24,
                            ),
                            physics: AlwaysScrollableScrollPhysics(),
                            child: InfoBase(
                              listData: state.productInfo?.data ?? [],
                            ),
                          ),
                        ),
                      );
                    } else if (state is ErrorGetDetailProductState) {
                      return Text(
                        state.msg,
                        style: AppStyle.DEFAULT_16_T,
                      );
                    } else
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 24,
                        ),
                        child: loadInfo(),
                      );
                  }),
            ),
            BlocBuilder<DetailProductBloc, DetailProductState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is UpdateGetDetailProductState)
                  return ButtonCustom(
                    onTap: () {
                      showThaoTac(context, _list);
                    },
                  );
                return ButtonCustom(
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
