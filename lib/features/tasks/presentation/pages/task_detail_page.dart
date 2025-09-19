import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g_task/core/utils/date_utils_helper.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:g_task/features/tasks/presentation/pages/task_form_page.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, this.task});

  final Task? task;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.task?.title ?? 'Détail de la tâche',
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormPage(task: widget.task),
                ),
              );
            },
            tooltip: 'Éditer',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            onPressed: () {
              context.read<TaskBloc>().add(
                DeleteTaskEvent(id: widget.task!.id),
              );
            },
            tooltip: 'Supprimer',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task?.description ?? 'Aucune description disponible.',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Créé le: ${widget.task != null ? DateUtilsHelper.formatDateTime(widget.task!.created_at) : 'N/A'}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.update,
                  size: 18,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dernière mise à jour: ${widget.task != null ? DateUtilsHelper.formatDateTime(widget.task!.updated_at) : 'N/A'}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              widget.task != null && !widget.task!.is_synced
                  ? '(Non synchronisé)'
                  : '',
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<TaskBloc>().add(
                    ToggleTaskCompletionEvent(task: widget.task!),
                  );
                  Navigator.pop(context);
                },
                icon: Icon(
                  widget.task!.is_completed
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                ),
                label: Text(
                  widget.task!.is_completed
                      ? 'Marquer comme non complétée'
                      : 'Marquer comme complétée',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
