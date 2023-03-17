import 'package:objectbox/objectbox.dart';
import 'package:todo/models/task.dart';

@Entity()
class Group {
  int id = 0;
  String name = '';
  int color;

  @Backlink('group')
  final tasks = ToMany<Task>();

  Group({
    required this.name,
    required this.color,
  });

  String tasksDescription() {
    final tasksCompleted = tasks.where((task) => task.completed).length;

    if (tasks.isEmpty) {
      return '';
    }

    return '$tasksCompleted of ${tasks.length}';
  }
}
