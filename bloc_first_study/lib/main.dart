import 'package:bloc_first_study/apis/login_api.dart';
import 'package:bloc_first_study/apis/notes_api.dart';
import 'package:bloc_first_study/block/actions.dart';
import 'package:bloc_first_study/block/app_bloc.dart';
import 'package:bloc_first_study/block/app_state.dart';
import 'package:bloc_first_study/dialogs/generic_dialog.dart';
import 'package:bloc_first_study/dialogs/loading_screen.dart';
import 'package:bloc_first_study/models.dart';
import 'package:bloc_first_study/strings.dart';
import 'package:bloc_first_study/views/iterable_list_view.dart';
import 'package:bloc_first_study/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display possible errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // if we are logged in, but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
