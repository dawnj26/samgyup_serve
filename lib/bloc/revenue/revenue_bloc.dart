import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/data/models/revenue_data_point.dart';
import 'package:samgyup_serve/ui/components/charts/revenue_line_chart.dart';

part 'revenue_event.dart';
part 'revenue_state.dart';
part 'revenue_bloc.freezed.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  RevenueBloc({
    required BillingRepository billingRepository,
  }) : _billingRepository = billingRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_PeriodChanged>(_onPeriodChanged);
  }

  final BillingRepository _billingRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<RevenueState> emit,
  ) async {
    emit(state.copyWith(status: RevenueStatus.loading));

    try {
      emit(
        state.copyWith(
          status: RevenueStatus.loaded,
          data: await getRevenueData(state.period),
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: RevenueStatus.error,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: RevenueStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPeriodChanged(
    _PeriodChanged event,
    Emitter<RevenueState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          period: event.period,
          status: RevenueStatus.loaded,
          data: await getRevenueData(event.period),
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: RevenueStatus.error,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: RevenueStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<List<RevenueDataPoint>> getRevenueData(ChartPeriod chartPeriod) async {
    final period = switch (chartPeriod) {
      ChartPeriod.weekly => Period.week,
      ChartPeriod.monthly => Period.month,
      ChartPeriod.yearly => Period.year,
    };
    final data = await _billingRepository.getRevenueData(period);
    final revenueData = data.map(RevenueDataPoint.fromJson).toList();
    return revenueData;
  }
}
