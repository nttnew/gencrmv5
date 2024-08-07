import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_crm/bloc/add_job_chance/add_job_chance_bloc.dart';
import 'package:gen_crm/bloc/add_service_voucher/add_service_bloc.dart';
import 'package:gen_crm/bloc/contact_by_customer/contact_by_customer_bloc.dart';
import 'package:gen_crm/bloc/contract/attack_bloc.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/bloc/contract/total_bloc.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';
import 'package:gen_crm/bloc/information_account/information_account_bloc.dart';
import 'package:gen_crm/bloc/list_note/add_note_bloc.dart';
import 'package:gen_crm/bloc/payment_contract/payment_contract_bloc.dart';
import 'package:gen_crm/bloc/policy/policy_bloc.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/bloc/report/report_general/report_general_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/support/detail_support_bloc.dart';
import 'package:gen_crm/bloc/support/support_bloc.dart';
import 'package:gen_crm/firebase/firebase_config.dart';
import 'package:gen_crm/my_app.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/storages.dart';
import 'api_resfull/api.dart';
import 'bloc/add_customer/add_customer_bloc.dart';
import 'bloc/blocs.dart';
import 'bloc/checkin_bloc/checkin_bloc.dart';
import 'bloc/clue/clue_bloc.dart';
import 'bloc/contract/customer_contract_bloc.dart';
import 'bloc/contract/phone_bloc.dart';
import 'bloc/detail_clue/detail_clue_bloc.dart';
import 'bloc/detail_product/detail_product_bloc.dart';
import 'bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'bloc/list_note/list_note_bloc.dart';
import 'bloc/manager_filter/manager_bloc.dart';
import 'bloc/product_customer_module/product_customer_module_bloc.dart';
import 'bloc/product_module/product_module_bloc.dart';
import 'bloc/readed_list_notification/readed_list_notifi_bloc.dart';
import 'bloc/report/car_report/car_report_bloc.dart';
import 'bloc/report/quy_so_report/quy_so_report_bloc.dart';
import 'bloc/report/report_employee/report_employee_bloc.dart';
import 'bloc/report/report_option/option_bloc.dart';
import 'bloc/report/report_bloc/report_bloc.dart';
import 'bloc/report/report_product/report_product_bloc.dart';
import 'bloc/work/detail_work_bloc.dart';
import 'bloc/work/work_bloc.dart';

Future main() async {
  Bloc.observer = SimpleBlocObserver();
  await dotenv.load(fileName: BASE_URL.ENV);
  shareLocal = await ShareLocal.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  UserRepository userRepository = UserRepository();
  await FirebaseConfig.initFireBase();
  await FirebaseConfig.requestPermission();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
            localRepository: const EventRepositoryStorage(),
          )..add(AuthenticationStateInit()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              userRepository: userRepository,
              localRepository: const EventRepositoryStorage(),
            ),
          ),
          BlocProvider<ChangePasswordBloc>(
            create: (context) => ChangePasswordBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ForgotPasswordOTPBloc>(
            create: (context) => ForgotPasswordOTPBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ResetPasswordBloc>(
            create: (context) => ResetPasswordBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ResendOTPBloc>(
            create: (context) => ResendOTPBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<InfoUserBloc>(
            create: (context) => InfoUserBloc(
                userRepository: userRepository,
                localRepository: const EventRepositoryStorage(),
                context: context),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListCustomerBloc>(
            create: (context) =>
                GetListCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListChanceBloc>(
            create: (context) =>
                GetListChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportProductBloc>(
            create: (context) =>
                ReportProductBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListDetailChanceBloc>(
            create: (context) =>
                GetListDetailChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailCustomerBloc>(
            create: (context) =>
                DetailCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailProductBloc>(
            create: (context) =>
                DetailProductBloc(userRepository: userRepository),
          ),
          BlocProvider<AddJobChanceBloc>(
            create: (context) =>
                AddJobChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<ContractBloc>(
            create: (context) => ContractBloc(userRepository: userRepository),
          ),
          BlocProvider<AddCustomerBloc>(
            create: (context) =>
                AddCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListClueBloc>(
            create: (context) =>
                GetListClueBloc(userRepository: userRepository),
          ),
          BlocProvider<GetDetailClueBloc>(
            create: (context) =>
                GetDetailClueBloc(userRepository: userRepository),
          ),
          BlocProvider<GetPolicyBloc>(
            create: (context) => GetPolicyBloc(userRepository: userRepository),
          ),
          BlocProvider<GetInfoBloc>(
              create: (context) =>
                  GetInfoBloc(userRepository: userRepository)),
          BlocProvider<FormAddBloc>(
            create: (context) => FormAddBloc(userRepository: userRepository),
          ),
          BlocProvider<AddDataBloc>(
            create: (context) => AddDataBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailContractBloc>(
            create: (context) =>
                DetailContractBloc(userRepository: userRepository),
          ),
          BlocProvider<WorkBloc>(
            create: (context) => WorkBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailWorkBloc>(
            create: (context) => DetailWorkBloc(userRepository: userRepository),
          ),
          BlocProvider<InforAccBloc>(
            create: (context) => InforAccBloc(userRepository: userRepository),
          ),
          BlocProvider<UnreadNotificationBloc>(
            create: (context) =>
                UnreadNotificationBloc(userRepository: userRepository),
          ),
          BlocProvider<ReadNotificationBloc>(
            create: (context) =>
                ReadNotificationBloc(userRepository: userRepository),
          ),
          BlocProvider<GetInfoAccBloc>(
            create: (context) => GetInfoAccBloc(userRepository: userRepository),
          ),
          BlocProvider<SupportBloc>(
            create: (context) => SupportBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailSupportBloc>(
            create: (context) =>
                DetailSupportBloc(userRepository: userRepository),
          ),
          BlocProvider<CustomerContractBloc>(
            create: (context) =>
                CustomerContractBloc(userRepository: userRepository),
          ),
          BlocProvider<ListNoteBloc>(
            create: (context) => ListNoteBloc(userRepository: userRepository),
          ),
          BlocProvider<AddNoteBloc>(
            create: (context) => AddNoteBloc(userRepository: userRepository),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(userRepository: userRepository),
          ),
          BlocProvider<ContactByCustomerBloc>(
            create: (context) =>
                ContactByCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<TotalBloc>(
            create: (context) => TotalBloc(userRepository: userRepository),
          ),
          BlocProvider<AttackBloc>(
            create: (context) => AttackBloc(userRepository: userRepository),
          ),
          BlocProvider<PhoneBloc>(
            create: (context) => PhoneBloc(userRepository: userRepository),
          ),
          BlocProvider<PaymentContractBloc>(
            create: (context) =>
                PaymentContractBloc(userRepository: userRepository),
          ),
          BlocProvider<OptionBloc>(
            create: (context) => OptionBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportEmployeeBloc>(
            create: (context) =>
                ReportEmployeeBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportBloc>(
            create: (context) => ReportBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportGeneralBloc>(
            create: (context) =>
                ReportGeneralBloc(userRepository: userRepository),
          ),
          BlocProvider<ServiceVoucherBloc>(
            create: (context) =>
                ServiceVoucherBloc(userRepository: userRepository),
          ),
          BlocProvider<ProductModuleBloc>(
            create: (context) =>
                ProductModuleBloc(userRepository: userRepository),
          ),
          BlocProvider<CarReportBloc>(
            create: (context) => CarReportBloc(userRepository: userRepository),
          ),
          BlocProvider<CheckInBloc>(
            create: (context) => CheckInBloc(userRepository: userRepository),
          ),
          BlocProvider<ProductCustomerModuleBloc>(
            create: (context) =>
                ProductCustomerModuleBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailProductCustomerBloc>(
            create: (context) =>
                DetailProductCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<ManagerBloc>(
            create: (context) => ManagerBloc(userRepository: userRepository),
          ),
          BlocProvider<QuySoReportBloc>(
            create: (context) =>
                QuySoReportBloc(userRepository: userRepository),
          ),
        ],
        child: ProviderScope(child: const MyApp()),
      ),
    ),
  );
}
