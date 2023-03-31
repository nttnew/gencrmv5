import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/policy/policy_bloc.dart';

import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({Key? key}) : super(key: key);
  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.PRIMARY_COLOR,
        title: Text(
          MESSAGES.POLICY,
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
        child:
            BlocBuilder<GetPolicyBloc, PolicyState>(builder: (context, state) {
          if (state is UpdateGetPolicyState) {
            return Text(
              state.policy!,
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
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  @override
  void initState() {
    GetPolicyBloc.of(context).add(InitGetPolicyEvent());
    super.initState();
  }
}
