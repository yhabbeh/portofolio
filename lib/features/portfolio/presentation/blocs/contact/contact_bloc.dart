import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/submit_contact.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final SubmitContact submitContact;

  ContactBloc({required this.submitContact}) : super(const ContactInitial()) {
    on<SubmitContactFormEvent>(_onSubmitContactForm);
  }

  Future<void> _onSubmitContactForm(
    SubmitContactFormEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(const ContactSubmitting());
    try {
      await submitContact(
        name: event.name,
        email: event.email,
        message: event.message,
      );
      emit(const ContactSuccess());
    } catch (e) {
      emit(ContactFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
