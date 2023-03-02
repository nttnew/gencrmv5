

import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/home/contract/ItemProductAdd.dart';
import 'package:gen_crm/screens/menu/home/contract/list_product.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';

import '../../../../models/product_model.dart';

class ProductContract extends StatefulWidget {
  ProductContract({Key? key,required this.data,required this.addProduct,required this.reload}) : super(key: key);
  List<ProductModel> data;
  Function addProduct;
  Function reload;

  @override
  State<ProductContract> createState() => _ProductContractState();
}

class _ProductContractState extends State<ProductContract> {
  List<ProductModel> productData=[];

  @override
  void initState() {
    setState((){
      productData=widget.data;
    });
    super.initState();
  }

  reload() async {
    await widget.reload();
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          productData.length>0? Column(
            children: List.generate(productData.length, (index) => ItemProductAdd(data:productData[index])),
          ):Container(),
          Center(
            child: GestureDetector(
              onTap: (){
                  AppNavigator.navigateAddProduct(widget.addProduct,reload,productData);
              },
              child: WidgetText(
                title: "Chọn sản phẩm",
                style: AppStyle.DEFAULT_14_BOLD.copyWith(color: COLORS.TEXT_BLUE_BOLD),
              ),
            ),
          )
        ],
      ),
    );
  }

}
