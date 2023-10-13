import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/policy/policy_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({Key? key}) : super(key: key);
  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(
          getT(KeyT.policy_terms)),
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
            return noData();
          }
        }),
      ),
    );
  }

  @override
  void initState() {
    GetPolicyBloc.of(context).add(InitGetPolicyEvent());
    super.initState();
  }
}
