import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:get/get.dart';

import '../../../../src/src_index.dart';

Widget fieldTextCar(
  CustomerIndividualItemData data,
  String value,
  Function(String) onChange,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textScaleFactor: MediaQuery.of(Get.context!).textScaleFactor,
          text: TextSpan(
            text: data.field_label ?? '',
            style: AppStyle.DEFAULT_14W600,
            children: <TextSpan>[
              data.field_require == 1
                  ? TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: COLORS.LIGHT_GREY,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: COLORS.ffBEB4B4,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 16,
              bottom: 16,
            ),
            child: Container(
              child: Text(
                '${value != '' ? value : (data.field_value ?? '')}',
                style: AppStyle.DEFAULT_14_BOLD,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
