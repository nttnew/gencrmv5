import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/screens/menu/home/contract/ItemProductAdd.dart';
import 'package:gen_crm/screens/menu/home/contract/list_product.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';

import '../../../../models/product_model.dart';

class ProductContract extends StatefulWidget {
  ProductContract(
      {Key? key,
      required this.data,
      required this.addProduct,
      required this.reload,
      this.neverHidden = false,
      this.canDelete = false,
      this.onDelete})
      : super(key: key);
  List<ProductModel> data;
  Function addProduct;
  Function reload;
  bool neverHidden;
  bool canDelete;
  Function(ProductModel productModel)? onDelete;

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
                            onDelete: widget.onDelete,
                            canDelete: widget.canDelete,
                            neverHidden: widget.neverHidden,
                            data: productData[index].item,
                            onPlus: (soLuong) {
                              // int indexSelect=listSelected.indexWhere((element) => element.id==state.listProduct[index].product_id!);
                              // if(indexSelect!=-1){
                              productData[index].soLuong = soLuong;
                              // }
                            },
                            onMinus: (soLuong) {
                              // int indexSelect=listSelected.indexWhere((element) => element.id==state.listProduct[index].product_id!);
                              // if(indexSelect!=-1){
                              productData[index].soLuong = soLuong;
                              // }
                            },
                            onDVT: (id, name) {
                              // int indexSelect=listSelected.indexWhere((element) => element.id==state.listProduct[index].product_id!);
                              // if(indexSelect!=-1){
                              productData[index].nameDvt = name;
                              productData[index].item.dvt = id;
                              // }
                            },
                            onVAT: (id, name) {
                              // int indexSelect=listSelected.indexWhere((element) => element.id==state.listProduct[index].product_id!);
                              // if(indexSelect!=-1){
                              productData[index].nameVat = name;
                              productData[index].item.vat = id;
                              // }
                            },
                            onGiamGia: (so, type) {
                              // int indexSelect=listSelected.indexWhere((element) => element.id==state.listProduct[index].product_id!);
                              // if(indexSelect!=-1){
                              productData[index].giamGia = so;
                              productData[index].typeGiamGia = type;
                              // }
                            },
                            model: productData[index],
                            listDvt: listDVT,
                            listVat: listVAT,
                          )),
                )
              : Container(),
          Center(
            child: GestureDetector(
              onTap: () {
                AppNavigator.navigateAddProduct(
                    widget.addProduct, reload, productData);
              },
              child: WidgetText(
                title: "Chọn sản phẩm",
                style: AppStyle.DEFAULT_14_BOLD
                    .copyWith(color: COLORS.TEXT_BLUE_BOLD),
              ),
            ),
          )
        ],
      ),
    );
  }
}
