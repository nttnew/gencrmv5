import 'package:flutter/material.dart';
import '../../../src/models/model_generator/detail_xe_dich_vu.dart';
import '../../../src/src_index.dart';

class ItemSanPham extends StatelessWidget {
  const ItemSanPham({
    Key? key,
    required this.dataDV,
  }) : super(key: key);
  final CTDichVu dataDV;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: COLORS.GREY,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dataDV.tenSanPham ?? '',
              style: AppStyle.DEFAULT_14_BOLD,
            ),
          ),
          Expanded(
            child: Text(
              '${dataDV.soLuong} ${dataDV.donViTinh}',
              style: AppStyle.DEFAULT_14_BOLD,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
