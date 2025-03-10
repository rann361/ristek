// lib/models/task.dart
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    this.isCompleted = false,
  });

  // Create a copy of the task with modified properties
  Task copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    bool? isCompleted,
  }) {
    return Task(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}