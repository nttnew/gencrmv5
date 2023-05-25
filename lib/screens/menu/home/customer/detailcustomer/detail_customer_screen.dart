import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/index.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../bloc/chance_customer/chance_customer_bloc.dart';
import '../../../../../bloc/clue_customer/clue_customer_bloc.dart';
import '../../../../../bloc/contract_customer/contract_customer_bloc.dart';
import '../../../../../bloc/job_customer/job_customer_bloc.dart';
import '../../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../../bloc/support_customer/support_customer_bloc.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/loading_api.dart';
import '../../../../../widgets/show_thao_tac.dart';
import '../../../attachment/attachment.dart';

class DetailCustomerScreen extends StatefulWidget {
  const DetailCustomerScreen({Key? key}) : super(key: key);

  @override
  State<DetailCustomerScreen> createState() => _DetailCustomerScreenState();
}

class _DetailCustomerScreenState extends State<DetailCustomerScreen>
    with SingleTickerProviderStateMixin {
  String id = Get.arguments[0];
  String name = Get.arguments[1];
  late TabController _tabController;
  int page = 0;
  bool drag = false;
  final List<ModuleThaoTac> list = [];

  @override
  void initState() {
    getThaoTac();
    _tabController = TabController(length: 6, vsync: this);
    Future.delayed(Duration(seconds: 0), () {
      ContractCustomerBloc.of(context).id = int.parse(id);
      DetailCustomerBloc.of(context)
          .add(InitGetDetailCustomerEvent(int.parse(id)));
      ListNoteBloc.of(context).add(InitNoteCusEvent(id, "1"));
      ClueCustomerBloc.of(context).add(InitGetClueCustomerEvent(int.parse(id)));
      ChanceCustomerBloc.of(context)
          .add(InitGetChanceCustomerEvent(int.parse(id)));
      ContractCustomerBloc.of(context)
          .add(InitGetContractCustomerEvent(int.parse(id)));
      JobCustomerBloc.of(context).add(InitGetJobCustomerEvent(int.parse(id)));
      SupportCustomerBloc.of(context)
          .add(InitGetSupportCustomerEvent(int.parse(id)));
    });
    super.initState();
  }

  getThaoTac() {
    if (DetailCustomerBloc.of(context).sdt != null)
      list.add(
        ModuleThaoTac(
          title: "Gọi điện",
          icon: ICONS.IC_PHONE_CUSTOMER_SVG,
          onThaoTac: () {
            Get.back();
            launchUrl(Uri(
                scheme: "tel",
                path: DetailCustomerBloc.of(context).sdt.toString()));
          },
        ),
      );

    list.add(
      ModuleThaoTac(
        title: "Thêm đầu mối",
        icon: ICONS.IC_ADD_CLUE_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateFormAdd('Thêm đầu mối', 11, id: int.parse(id));
        },
      ),
    );

    list.add(ModuleThaoTac(
      title: "Thêm cơ hội",
      icon: ICONS.IC_ADD_CHANCE_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd('Thêm cơ hội', 12, id: int.parse(id));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm hợp đồng",
      icon: ICONS.IC_ADD_CONTRACT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddContract(customer_id: id, title: 'hợp đồng');
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm công việc",
      icon: ICONS.IC_ADD_WORD_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd('Thêm công việc', 14, id: int.parse(id));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm hỗ trợ",
      icon: ICONS.IC_ADD_SUPPORT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormAdd('Thêm hỗ trợ', 15, id: int.parse(id));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Thêm thảo luận",
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(1, id);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.KHACH_HANG,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, 1);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () => DetailCustomerBloc.of(context)
                .add(DeleteCustomerEvent(int.parse(id))),
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          centerTitle: false,
          title: WidgetText(
              title: name,
              style: AppStyle.DEFAULT_16.copyWith(fontWeight: FontWeight.w700)),
          leading: Padding(
              padding: EdgeInsets.only(left: 30),
              child: InkWell(
                  onTap: () => AppNavigator.navigateBack(),
                  child: Icon(Icons.arrow_back, color: Colors.black))),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: BlocListener<DetailCustomerBloc, DetailCustomerState>(
          listener: (context, state) async {
            if (state is SuccessDeleteCustomerState) {
              LoadingApi().popLoading();
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: "Thành công",
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                  GetListCustomerBloc.of(context)
                      .add(InitGetListOrderEvent("", 1, ""));
                },
              );
            } else if (state is ErrorDeleteCustomerState) {
              LoadingApi().popLoading();
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: state.msg,
                textButton1: "Quay lại",
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                },
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: SafeArea(
              child: Scaffold(
                appBar: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: HexColor("#006CB1"),
                  unselectedLabelColor: HexColor("#697077"),
                  labelStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  indicatorColor: HexColor("#006CB1"),
                  tabs: <Widget>[
                    Tab(
                      text: "Thông tin chung",
                    ),
                    Tab(
                      text: "Đầu mối",
                    ),
                    Tab(
                      text: "Cơ hội",
                    ),
                    Tab(
                      text: "Hợp đồng",
                    ),
                    Tab(
                      text: "Công việc",
                    ),
                    Tab(
                      text: "Hỗ trợ",
                    ),
                  ],
                ),
                body: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            GeneralInfoCustomer(id: id),
                            ClueCustomer(id: id),
                            ChanceCustomer(id: id),
                            ConstractCustomer(id: id),
                            WorkCustomer(id: id),
                            SupportCustomer(id: id),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppValue.heights * 0.02,
                      ),
                      ButtonThaoTac(onTap: () {
                        showThaoTac(context, list);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
