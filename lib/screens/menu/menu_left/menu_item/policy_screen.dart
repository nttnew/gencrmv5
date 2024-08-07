import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/policy/policy_bloc.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/appbar_base.dart';
import '../../widget/error_item.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({Key? key}) : super(key: key);
  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  void initState() {
    GetPolicyBloc.of(context).add(InitGetPolicyEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(getT(KeyT.policy_terms)),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child:
            BlocBuilder<GetPolicyBloc, PolicyState>(builder: (context, state) {
          if (state is UpdateGetPolicyState) {
            if (state.policy == '' || state.policy == null) return noData();
            return TextAnimator(
              state.policy ?? '',
              textAlign: TextAlign.justify,
              style: AppStyle.DEFAULT_16_T,
              atRestEffect: WidgetRestingEffects.bounce(numberOfPlays: 1),
            );
          } else if (state is ErrorGetPolicyState) {
            return ErrorItem(
              error: state.msg,
              onPressed: () =>
                  GetPolicyBloc.of(context).add(InitGetPolicyEvent()),
            );
          } else {
            return SizedBox();
          }
        }),
      ),
    );
  }
}
