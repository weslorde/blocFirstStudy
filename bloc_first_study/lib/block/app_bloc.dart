import 'package:bloc/bloc.dart';
import 'package:bloc_first_study/apis/login_api.dart';
import 'package:bloc_first_study/apis/notes_api.dart';
import 'package:bloc_first_study/block/actions.dart';
import 'package:bloc_first_study/block/app_state.dart';
import 'package:bloc_first_study/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
      : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //Start loading
        emit(
          const AppState(
            isLoading: true,
            loginError: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );
        // log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginErros.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );
    on<LoadNotesAction>(
      (event, emit) async {
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
        // get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle.fooBar()) {
          //invalid login handle
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErros.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        // valid login handle and want to fetch notes
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
