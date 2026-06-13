import 'package:equatable/equatable.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {
  const ContactInitial();
}

class ContactSubmitting extends ContactState {
  const ContactSubmitting();
}

class ContactSuccess extends ContactState {
  const ContactSuccess();
}

class ContactFailure extends ContactState {
  final String error;

  const ContactFailure(this.error);

  @override
  List<Object?> get props => [error];
}
