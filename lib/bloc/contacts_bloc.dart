import 'package:bloc/bloc.dart';
import 'package:lista_de_contatos/models/contact.dart';
import 'package:lista_de_contatos/service/contactservice.dart';

import 'package:meta/meta.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContatosBloc extends Bloc<ContatosEvent, ContatosState> {
  final ContatoService contatosService;
  ContatosBloc(this.contatosService) : super(ContatoLoading()) {
    on<ContatosEvent>((event, emit) async {
      if (event is FetchContatos) {
        try {
          final list = await contatosService.getContatos();
          emit(ContatoListState(list));
        } catch (e) {
          emit(ContatoPageError(e.toString()));
        }
      } else if (event is UpdateContatos) {
        try {
          await contatosService.updateContato(
              event.contato as Contact, event.id);
        } catch (e) {
          emit(ContatoPageError(e.toString()));
        }
      } else if (event is AddContatos) {
        try {
          await contatosService.addContato(event.contato as Contact);
          emit(ContatoAdded());
        } catch (e) {
          emit(ContatoPageError(e.toString()));
        }
      } else if (event is DeleteContatos) {
        try {
          await contatosService.deleteContato(event.id);
          emit(ContatoDeleted());
        } catch (e) {
          emit(ContatoPageError(e.toString()));
        }
      }
    });
  }
}
