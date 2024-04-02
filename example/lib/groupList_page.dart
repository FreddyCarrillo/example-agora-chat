import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:example/chatGroup_page.dart';
import 'package:example/custom_video_message/custom_message_page.dart';
import 'package:flutter/material.dart';

class GroupListPage extends StatefulWidget {
  final List<String> groupIds; // Lista de ID de grupos creados

  const GroupListPage({Key? key, required this.groupIds}) : super(key: key);

  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final TextEditingController _memberController = TextEditingController();
  String _groupId = '';
  List<String> _members = [];

  @override
  void initState() {
    super.initState();
    // Cargar la lista de miembros cuando se carga la página por primera vez
    _loadMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My chat groups'),
      ),
      body: ListView.builder(
        itemCount: widget.groupIds.length,
        itemBuilder: (context, index) {
          final groupId = widget.groupIds[index];
          return Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              ListTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0), // Relleno de 8 en todos los lados
                  child: Text(
                    'Group $groupId',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, // Negrita
                        color: Colors.black, // Color del texto
                        fontSize: 16),
                  ),
                ),
              ),
              _buildMemberList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _memberController,
                        decoration: InputDecoration(
                          labelText: 'Enter the ID',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _groupId = groupId;
                        _addMember();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        'Add member',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _viewConversation(groupId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[400]
                ),
                child: Text(
                  'View conversation',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  // Función para cargar la lista de miembros del grupo
  void _loadMemberList() async {
    try {
      ChatCursorResult<String> result =
          await ChatClient.getInstance.groupManager.fetchMemberListFromServer(
        "242308456972289",
      );
      setState(() {
        _members = result.data;
      });
    } on ChatError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error al cargar la lista de miembros: ${e.description}'),
        ),
      );
    }
  }

  // Widget para mostrar la lista de miembros
  Widget _buildMemberList() {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Members",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                _members.map((member) => _buildMemberTile(member)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(String member) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green, 
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        member,
        style: TextStyle(
          color: Colors.white, 
        ),
      ),
    );
  }

  // Función para agregar un miembro al grupo
  void _addMember() async {
    List<String> members = [_memberController.text];
    try {
      await ChatClient.getInstance.groupManager.addMembers("242308456972289", members);
      print('_groupId');
      print(_groupId);
      _loadMemberList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Miembro agregado al grupo $_groupId'),
        ),
      );
    } on ChatError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar miembro: ${e.description}'),
        ),
      );
    }
  }

  // Función para ver la conversación de un grupo
  void _viewConversation(String groupId) async {
    try {
      // GroupChat
      ChatConversation? conv = 
          await ChatClient.getInstance.chatManager.getConversation("242308456972289", type : ChatConversationType.GroupChat);
      if (conv != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CustomMessagesPage(conv);
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'No se pudo obtener la conversación para el grupo $groupId'),
          ),
        );
      }
    } on ChatError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener la conversación: ${e.description}'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _memberController.dispose();
    super.dispose();
  }
}
