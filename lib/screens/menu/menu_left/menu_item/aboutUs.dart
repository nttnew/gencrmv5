import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    GetInforBloc.of(context).add(InitGetInforEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.PRIMARY_COLOR,
        title: Text(
          'Giới thiệu',
          style: AppStyle.DEFAULT_18_BOLD,
        ),
        leading: _buildBack(),
        toolbarHeight: AppValue.heights * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: BlocBuilder<GetInforBloc, InforState>(builder: (context, state) {
          if (state is UpdateGetInforState) {
            return Text(
              state.gioi_thieu!,
              textAlign: TextAlign.justify,
              style: AppStyle.DEFAULT_16_T,
            );
          } else {
            return Center(
              child: WidgetText(
                title: 'Không có dữ liệu',
                style: AppStyle.DEFAULT_18_BOLD,
              ),
            );
          }
        }),
      ),
    );
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.IC_BACK_PNG,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }
}
