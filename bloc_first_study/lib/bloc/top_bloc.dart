import 'package:bloc_first_study/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  TopBloc({
    Duration ? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
