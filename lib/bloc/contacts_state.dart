part of 'contacts_bloc.dart';

@immutable
abstract class ContatosState {}

class ContatoLoading extends ContatosState {}

class ContatoListState extends ContatosState {
  final ContactList contatoList;
  ContatoListState(this.contatoList);
}

class ContatoPageError extends ContatosState {
  final String message;
  ContatoPageError(this.message);
}

class ContatoAdded extends ContatosState {}

class ContatoDeleted extends ContatosState {}

class ContatoUpdated extends ContatosState {}
