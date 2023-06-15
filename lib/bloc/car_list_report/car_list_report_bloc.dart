import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/response_bao_cao.dart';

part 'car_list_report_event.dart';
part 'car_list_report_state.dart';

class CarListReportBloc extends Bloc<CarListReportEvent, CarListReportState> {
  final UserRepository userRepository;
  final BehaviorSubject<String?> statusCar = BehaviorSubject();
  int page = BASE_URL.PAGE_DEFAULT;
  bool isTotal = true;
  List<ItemResponseReportCar> listData = [];
  CarListReportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListCarListReport());

  @override
  Stream<CarListReportState> mapEventToState(CarListReportEvent event) async* {
    if (event is GetListReportCar) {
      yield* getListReportCar(
        timeTo: event.timeTo,
        timeFrom: event.timeFrom,
        time: event.time,
        diemBan: event.diemBan,
        page: event.page,
        trangThai: event.trangThai,
      );
    }
  }

  Stream<CarListReportState> getListReportCar({
    required String page,
    String? timeFrom,
    String? timeTo,
    String? diemBan,
    String? time,
    required String trangThai,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListBaoCao(
        time: time,
        timeFrom: timeFrom,
        timeTo: timeTo,
        diemBan: diemBan,
        page: page,
        trangThai: trangThai,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == BASE_URL.PAGE_DEFAULT.toString()) {
          listData = [];
        }
        isTotal = (response.data?.lists?.length ?? 0) == BASE_URL.SIZE_DEFAULT;
        yield SuccessGetCarListReportState([...listData,...response.data?.lists ?? []]);
        listData.addAll(response.data?.lists ?? []);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else{
        yield ErrorGetListCarListReportState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetListCarListReportState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CarListReportBloc of(BuildContext context) =>
      BlocProvider.of<CarListReportBloc>(context);
}
