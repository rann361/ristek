import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ristek/item/task.dart';
import 'package:ristek/pages/addtask_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Example list of tasks
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Mobile Development Ristek',
      description: 'Finish the UI and implement all features',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 2)),
      category: 'Personal',
    ),
    Task(
      id: '2',
      title: 'Jogging',
      description: '5 km running',
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 1, hours: 1)),
      category: 'Health',
    ),
    Task(
      id: '3',
      title: 'Study for UTS',
      description: 'Learn from chapter 2',
      startDate: DateTime.now().add(const Duration(hours: 3)),
      endDate: DateTime.now().add(const Duration(hours: 6)),
      category: 'Academic',
    ),
  ];

  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = List.from(tasks);
  }

Future<void> _navigateToAddTask({Task? task}) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddTaskPage(
        isEditing: task != null, // Only true when editing an existing task
        task: task, // Pass the task when editing
      ),
    ),
  );

  if (result != null) {
    if (result is Task) {
      setState(() {
        if (task != null) {
          // Update existing task
          final index = tasks.indexWhere((t) => t.id == task.id);
          if (index != -1) {
            tasks[index] = result;
          }
        } else {
          // Add new task
          tasks.add(result);
        }
        // Update filtered tasks
        _filteredTasks = List.from(tasks);
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(task != null ? 'Task updated successfully' : 'Task added successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (result == null && task != null) {
      // Handle task deletion (when result is null from the delete operation)
      _deleteTask(task.id);
    }
  }
}

  void _handleTaskCompletion(Task task) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
        _filteredTasks = List.from(tasks);
      }
    });
  }

  void _deleteTask(String id) {
    final deletedTask = tasks.firstWhere((task) => task.id == id);
    final deletedIndex = tasks.indexWhere((task) => task.id == id);
    
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _filteredTasks = List.from(tasks);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedTask.title} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              tasks.insert(deletedIndex, deletedTask);
              _filteredTasks = List.from(tasks);
            });
          },
        ),
      ),
    );
  }

  void _runFilter(String keyword) {
    List<Task> results = [];
    if (keyword.isEmpty) {
      results = List.from(tasks);
    } else {
      results = tasks
          .where((task) =>
              task.title.toLowerCase().contains(keyword.toLowerCase()) ||
              task.description.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredTasks = results;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'health':
        return Colors.green;
      case 'personal':
        return Colors.purple;
      case 'daily task':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu,
              color: Colors.black,
              size: 30,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // Welcome Text with Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Tasks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tasks.where((task) => task.isCompleted).length} of ${tasks.length} tasks completed',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Box
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                  hintText: 'Search tasks',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Task List
            Expanded(
              child: _filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 70,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a new task to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        final Color categoryColor = _getCategoryColor(task.category);
                        
                        return Dismissible(
                          key: Key(task.id),
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteTask(task.id);
                          },
                          child: GestureDetector(
                            onTap: () => _navigateToAddTask(task: task),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 4,
                                          decoration: BoxDecoration(
                                            color: categoryColor,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: task.isCompleted 
                                                      ? TextDecoration.lineThrough 
                                                      : null,
                                                  color: task.isCompleted 
                                                      ? Colors.grey 
                                                      : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                task.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  decoration: task.isCompleted 
                                                      ? TextDecoration.lineThrough 
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _handleTaskCompletion(task),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: task.isCompleted ? categoryColor : Colors.transparent,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: categoryColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: task.isCompleted
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('MMM d, h:mm a').format(task.startDate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.label_outline,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: categoryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            task.category,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: categoryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),                              
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}