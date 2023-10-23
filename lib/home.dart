import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_contatos/bloc/contacts_bloc.dart';
import 'package:lista_de_contatos/service/contactservice.dart';

import 'models/contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final contactsBloc = ContatosBloc(ContatoService());
  final _newContactNameController = TextEditingController();
  final _newContactPhoneController = TextEditingController();

  @override
  void initState() {
    contactsBloc.add(FetchContatos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
      ),
      body: BlocListener<ContatosBloc, ContatosState>(
        bloc: contactsBloc,
        listener: (context, state) {
          if (state is ContatoAdded) {
            contactsBloc.add(FetchContatos());
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text('Contact Added')));
          } else if (state is ContatoDeleted) {
            contactsBloc.add(FetchContatos());
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text('Contact Deleted')));
          } else if (state is ContatoUpdated) {
            contactsBloc.add(FetchContatos());
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contato Atualizado')));
          }
        },
        child: BlocBuilder<ContatosBloc, ContatosState>(
          bloc: contactsBloc,
          builder: (context, state) {
            if (state is ContatoListState &&
                state.contatoList.contact != null) {
              return mainBody(state.contatoList);
            } else if (state is ContatoPageError) {
              // print(state.message)l÷÷
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: floatingButton(),
    );
  }

  Widget mainBody(ContactList contactlist) {
    var contacts = contactlist.contact;
    return ListView.builder(
      itemCount: contacts!.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          title: (contact.name != null) ? Text(contact.name!) : null,
          subtitle:
              (contact.phone != null) ? Text(contact.phone!.toString()) : null,
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.pop(context);
                      editarContato(context, contact);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteContato(contact);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void editarContato(BuildContext context, Contact _contact) async {
    _newContactNameController.text = _contact.name!;
    _newContactPhoneController.text = _contact.phone!.toString();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Contato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newContactNameController,
              onChanged: (value) => _contact.name = value,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newContactPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              contactsBloc.add(DeleteContatos(_contact.sId!));
              contactsBloc.add(AddContatos(contactsBloc));
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _addContato() {
    String? Nome = _newContactNameController.text;
    String? Telefone = _newContactPhoneController.text;

    if (Nome.isEmpty || Telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Os campos não pode ficar vazios")));
      return;
    }

    Contact contato =
        Contact(nome: Nome, telefone: int.parse(Telefone), sId: null);
    contactsBloc.add(AddContatos(contato as ContatosBloc));
  }

  void _deleteContato(Contact contact) {
    contactsBloc.add(DeleteContatos(contact.sId!));
  }

  Widget floatingButton() {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newContactNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newContactPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _newContactNameController.text = "";
                _newContactPhoneController.text = "";
                _addContato();
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
      child: const Icon(Icons.add),
    );
  }
}
