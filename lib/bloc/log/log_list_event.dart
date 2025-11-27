part of 'log_list_bloc.dart';

@freezed
class LogListEvent with _$LogListEvent {
  const factory LogListEvent.started() = _Started;
  const factory LogListEvent.loadMore() = _LoadMore;
  const factory LogListEvent.refresh() = _Refresh;
  const factory LogListEvent.filterByAction(LogAction? action) =
      _FilterByAction;
}
