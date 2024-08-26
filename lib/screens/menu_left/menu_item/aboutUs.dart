import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../widget/error_item.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    GetInfoBloc.of(context).add(InitGetInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(getT(KeyT.introduce)),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: BlocBuilder<GetInfoBloc, InfoState>(builder: (context, state) {
          if (state is UpdateGetInfoState) {
            if (state.gioiThieu == '' || state.gioiThieu == null)
              return noData();
            return TextAnimator(
              state.gioiThieu ?? '',
              textAlign: TextAlign.justify,
              style: AppStyle.DEFAULT_16_T,
              atRestEffect: WidgetRestingEffects.bounce(numberOfPlays: 1),
            );
          } else if (state is ErrorGetInfoState) {
            return ErrorItem(
              error: state.msg,
              onPressed: () => GetInfoBloc.of(context).add(InitGetInfoEvent()),
            );
          } else {
            return SizedBox();
          }
        }),
      ),
    );
  }
}
