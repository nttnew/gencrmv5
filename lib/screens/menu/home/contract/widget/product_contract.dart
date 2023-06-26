import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/screens/menu/home/contract/widget/list_product.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import '../../../../../models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ProductContract extends StatefulWidget {
  ProductContract({
    Key? key,
    required this.data,
    required this.addProduct,
    required this.reload,
    this.neverHidden = false,
    this.canDelete = false,
  }) : super(key: key);
  final List<ProductModel> data;
  final Function addProduct;
  final Function reload;
  final bool neverHidden;
  final bool canDelete;

  @override
  State<ProductContract> createState() => _ProductContractState();
}

class _ProductContractState extends State<ProductContract> {
  List<ProductModel> productData = [];
  UserRepository userRepository = UserRepository();
  List<List> listDVT = [];
  List<List> listVAT = [];
  @override
  void initState() {
    setState(() {
      productData = widget.data;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await userRepository.getListProduct("1", "");
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (listVAT.isEmpty) {
          listVAT = response.data!.vats!;
        }

        if (listDVT.isEmpty) {
          listDVT = response.data!.units!;
        }
      }
    });
    super.initState();
  }

  reload() async {
    await widget.reload();
    setState(() {});
  }

  void removeProduct(ProductModel productModel) {
    setState(() {
      productData.remove(productModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          productData.length > 0
              ? Column(
                  children: List.generate(
                      productData.length,
                      (index) => ItemProduct(
                            onDelete: removeProduct,
                            canDelete: widget.canDelete,
                            neverHidden: widget.neverHidden,
                            data: productData[index].item,
                            onPlus: (soLuong) {
                              productData[index].soLuong = soLuong;
                            },
                            onMinus: (soLuong) {
                              productData[index].soLuong = soLuong;
                            },
                            onDVT: (id, name) {
                              productData[index].nameDvt = name;
                              productData[index].item.dvt = id;
                            },
                            onVAT: (id, name) {
                              productData[index].nameVat = name;
                              productData[index].item.vat = id;
                            },
                            onGiamGia: (so, type) {
                              productData[index].giamGia = so;
                              productData[index].typeGiamGia = type;
                            },
                            onPrice: (price) {
                              productData[index].item.sell_price = price;
                            },
                            model: productData[index],
                            listDvt: listDVT,
                            listVat: listVAT,
                            onReload: () {
                              reload();
                            },
                          )),
                )
              : Container(),
          Center(
            child: GestureDetector(
              onTap: () {
                AppNavigator.navigateAddProduct(
                    widget.addProduct, reload, productData);
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: COLORS.TEXT_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                      color: COLORS.TEXT_COLOR,
                    )),
                child: WidgetText(
                  title: AppLocalizations.of(Get.context!)
                      ?.select_product??'',
                  style: AppStyle.DEFAULT_14_BOLD.copyWith(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
