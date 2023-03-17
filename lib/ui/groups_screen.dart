import 'package:flutter/material.dart';
import 'package:todo/models/group.dart';
import 'package:todo/ui/add_group_screen.dart';
import 'objectbox.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _groups = <Group>[];
  late final Store _store;
  late final Box<Group> _groupsBox;

  Future<vodi> _loadStore() async {
    _store = await openStore();
    _groupsBox = _store.box<Group>();
    _loadGroups();
  }

  void _loadGroups() {
    _groups.clear();
    setState(() {
      _groups.addAll(_groupsBox.getAll());
    });
  }

  @override
  void initState() {
    _loadStore();
    _loadGroups();
    supe.initState();
  }

  Future<void> _addGroup() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AddGroupScreen(),
    );

    if (result != null && result is Group) {
      _groupsBox.put(result);
      _loadGroups();
    }
  }

  // Future<void> _goToTasks(Group group) async {
  //   await Navigator.of(context).push(MaterialPageRoute(
  //       builder: (_) => TasksScreen(group: group, store: _store)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
      ),
      body: _groups.isEmpty
          ? const Center(
              child: Text('There are no Groups'),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return _GroupItem(
                  onTap: () => null, //_goToTasks(group),
                  group: group,
                ); // _GroupItem
              },
            ), //GridView
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add group'),
        onPressed: _addGroup,
      ),
    );
  }
}

class _GroupItem extends StatelessWidget {
  const _GroupItem({
    required this.group,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final description = group.tasksDescription();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(group.color),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}