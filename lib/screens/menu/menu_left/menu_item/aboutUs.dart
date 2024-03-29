import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';

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
      appBar: AppbarBaseNormal(getT(KeyT.introduce)),
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
            return noData();
          }
        }),
      ),
    );
  }
}
