import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g_task/core/utils/validator.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:g_task/features/tasks/presentation/widgets/custom_text_form_field.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.task != null) {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          updated_at: DateTime.now(),
          is_synced: false,
        );

        context.read<TaskBloc>().add(UpdateTaskEvent(task: updatedTask));
      } else {
        // Create new task
        context.read<TaskBloc>().add(
          CreateTaskEvent(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la tâche' : 'Nouvelle tâche'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8.0,
              children: [
                CustomTextFormField(
                  label: 'Titre',
                  verticalPadding: 12,
                  horizontalPadding: 12,
                  controller: _titleController,
                  validator: (value) => Validators.title(value),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hint: 'Description',
                  horizontalPadding: 12,
                  controller: _descriptionController,
                  validator: (value) => Validators.description(value),
                  maxLines: 15,
                  keyboardType: TextInputType.multiline,
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),

      // Boutons toujours visibles en bas
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.cancel),
                label: Text('Annuler'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
                onPressed: _submitForm,
                icon: Icon(isEditing ? Icons.update : Icons.add),
                label: Text(isEditing ? 'Mettre à jour' : 'Créer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
