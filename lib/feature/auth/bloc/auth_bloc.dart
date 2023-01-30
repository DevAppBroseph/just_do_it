import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<SendProfileEvent>(_sendProfile);
    on<ConfirmCodeEvent>(_confirmCode);
  }

  void _sendProfile(SendProfileEvent event, Emitter<AuthState> emit) async {
    await Repository().sendProfile(event.userRegModel);
  }

  void _confirmCode(ConfirmCodeEvent event, Emitter<AuthState> emit) async {
    await Repository().confirmCode(event.phone, event.code);
  }
}
