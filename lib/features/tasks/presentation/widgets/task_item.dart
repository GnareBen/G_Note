import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g_task/core/utils/date_utils_helper.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:g_task/features/tasks/presentation/pages/task_detail_page.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmer'),
              content: const Text(
                'Voulez-vous vraiment supprimer cette tâche ?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<TaskBloc>().add(DeleteTaskEvent(id: task.id));
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Checkbox remplacée par un indicateur circulaire
                InkWell(
                  onTap: () {
                    context.read<TaskBloc>().add(
                      ToggleTaskCompletionEvent(task: task),
                    );
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: task.is_completed
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceVariant,
                    child: Icon(
                      task.is_completed ? Icons.check : Icons.circle_outlined,
                      color: task.is_completed
                          ? Colors.white
                          : theme.colorScheme.outline,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Texte principal (title + description + date)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.is_completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (task.description != null &&
                          task.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            task.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            task.is_synced
                                ? Icons.cloud_done
                                : Icons.cloud_off_outlined,
                            size: 16,
                            color: task.is_synced
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateUtilsHelper.formatDateTime(task.updated_at),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bouton édition
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
