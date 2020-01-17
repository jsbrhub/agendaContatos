import 'dart:io';
import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_page.dart';


enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    /*Contact c = Contact();
    c.name = "Jessyca Borges";
    c.email = "developerjessicaborges@gmail.com";
    c.phone = "13458745";
    c.img = "imgteste";

    helper.saveContact(c);*/

    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
           itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
             const PopupMenuItem(
                 child: Text("Ordenar de A-Z"),
                 value: OrderOptions.orderaz,
             ),
             const PopupMenuItem(
                 child: Text("Ordenar de Z-A"),
                 value: OrderOptions.orderza,
             ),
           ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          // ignore: missing_return
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 63.0,
                height: 63.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                        FileImage(File(contacts[index].img)) :
                         AssetImage("img/person.png")
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0,
                      ),
                    ), Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0,
                      ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        __showOptions(context, index);
      },
    );
  }
  void __showOptions (BuildContext context, int index){
     showModalBottomSheet(
         context: context,
         builder: (context){
           return BottomSheet(
             onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text("Ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: (){
                            launch("tel:${contacts[index].phone}");
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text("Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text("Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: (){
                            helper.deleteContact(contacts[index].id);
                           setState(() {
                             contacts.removeAt(index);
                             Navigator.pop(context);
                           });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
           );
         });
  }

  // uma função que não retorna nada, serve para centralizar o condigo de mostrar o contato, porque vamos chamar tanto no botao de adicionar quanto clicar na foto do contato
  // com parametro opcional
  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if (recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList (OrderOptions result){
    switch (result){
      case OrderOptions.orderaz:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo((b.name.toLowerCase()));
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a,b) {
          return b.name.toLowerCase().compareTo((a.name.toLowerCase()));
        });
        break;
    }
    setState(() {

    });
  }

}