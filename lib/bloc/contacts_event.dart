part of 'contacts_bloc.dart';

@immutable
abstract class ContatosEvent {}

class FetchContatos extends ContatosEvent {}

class UpdateContatos extends ContatosEvent {
  final ContatosBloc contato;
  final String id;
  UpdateContatos(this.contato, this.id);
}

class DeleteContatos extends ContatosEvent {
  final String id;
  DeleteContatos(this.id);
}

class AddContatos extends ContatosEvent {
  final ContatosBloc contato;
  AddContatos(this.contato);
}
