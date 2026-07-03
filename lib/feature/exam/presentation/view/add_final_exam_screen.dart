import 'dart:developer';
import 'package:e_cource/feature/exam/presentation/provider/exam_local_provider.dart';
import 'package:e_cource/feature/exam/presentation/provider/add_exam_firebase_provider.dart';
import 'package:e_cource/feature/exam/data/model/exam_model.dart';
import 'package:e_cource/feature/exam/data/model/exam_question_model.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:toastification/toastification.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddFinalExamScreen extends StatelessWidget {
  final String courseId;
  final String moduleId;

  const AddFinalExamScreen({
    super.key,
    required this.courseId,
    required this.moduleId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamLocalProvider(),
      child: _AddFinalExamView(courseId: courseId, moduleId: moduleId),
    );
  }
}

class _AddFinalExamView extends StatelessWidget {
  final String courseId;
  final String moduleId;

  const _AddFinalExamView({
    required this.courseId,
    required this.moduleId,
  });

  static const _fieldFill = Color(0xFFF0F0F0);

  Widget _sectionLabel(String title, String subtitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      );

  InputDecoration _fieldDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        filled: true,
        fillColor: _fieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        isDense: true,
      );

  Widget _primaryBtn(String label, VoidCallback onTap) => ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 13)),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );

  Widget _buildDurationDropdown(BuildContext context, ExamLocalProvider p) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Duration',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: _fieldFill,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: p.selectedDuration,
                hint: Text('Select minutes',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 13)),
                items: ExamLocalProvider.durationOptions
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text('$m min',
                              style: const TextStyle(fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (v) =>
                    context.read<ExamLocalProvider>().setDuration(v),
              ),
            ),
          ),
        ],
      );

  Widget _buildExamDetails(BuildContext context, ExamLocalProvider p) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Exams Details', 'Enter about exams details'),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Duration dropdown
                Expanded(
                  child: _buildDurationDropdown(context, p),
                ),
                const SizedBox(width: 12),
                // Total Marks text field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Marks',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: p.totalMarkCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDec('enter total mark'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Pass Marks text field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pass Marks',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: p.passMarkCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDec('enter pass mark'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildExamTerms(BuildContext context, ExamLocalProvider p) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Exam Terms', 'add terms of this exams'),
            const SizedBox(height: 14),
            ...p.termCtrls.asMap().entries.map((e) {
              final i = e.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: AppColors.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                            controller: e.value,
                            decoration: _fieldDec('Enter Here'))),
                    if (p.termCtrls.length > 1)
                      IconButton(
                        onPressed: () =>
                            context.read<ExamLocalProvider>().removeTerm(i),
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red, size: 20),
                      ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: _primaryBtn('Add Another',
                  () => context.read<ExamLocalProvider>().addTerm()),
            ),
          ],
        ),
      );

  //  Questions 
  Widget _buildQuestions(BuildContext context, ExamLocalProvider p) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Questions', 'add questions for this exmas'),
            const SizedBox(height: 14),
            ...p.questions.asMap().entries.map((e) {
              return _buildQuestionBlock(context, e.key, e.value, p);
            }),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: _primaryBtn('Add Another Question',
                  () => context.read<ExamLocalProvider>().addQuestion()),
            ),
          ],
        ),
      );

  Widget _buildQuestionBlock(
      BuildContext context, int qi, ExamQuestion q, ExamLocalProvider p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question field
          Row(
            children: [
              Icon(Icons.check_circle,
                  color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: TextField(
                      controller: q.questionCtrl,
                      decoration: _fieldDec('Question'))),
              if (p.questions.length > 1)
                IconButton(
                  onPressed: () =>
                      context.read<ExamLocalProvider>().removeQuestion(qi),
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.red, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Options
          ...q.optionCtrls.asMap().entries.map((oe) {
            final oi = oe.key;
            final label = q.labelFor(oi);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text('$label)',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                      child: TextField(
                          controller: oe.value,
                          decoration: _fieldDec('Enter Answer'))),
                  if (q.optionCtrls.length > 2)
                    IconButton(
                      onPressed: () => context
                          .read<ExamLocalProvider>()
                          .removeOption(qi, oi),
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.red, size: 18),
                    ),
                ],
              ),
            );
          }),

          // Add option + correct answer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<ExamLocalProvider>().addOption(qi),
                child: Text(
                  'Add Another Option',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
              Row(
                children: [
                  Text('Choose the right answer',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(width: 8),
                  ...q.optionLabels.map((label) {
                    final selected = q.correctAnswer == label;
                    return GestureDetector(
                      onTap: () => context
                          .read<ExamLocalProvider>()
                          .setCorrectAnswer(qi, label),
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryColor
                              : Colors.white,
                          border: Border.all(
                              color: selected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  Retry Settings 
  Widget _buildRetrySettings(BuildContext context, ExamLocalProvider p) =>
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Retry Settings', 'add about exam retry options'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Yes / No
                Row(
                  children: [
                    const Text('Do You Provide Retry Options:',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 12),
                    _retryChoice(context, 'Yes', true, p),
                    const SizedBox(width: 8),
                    _retryChoice(context, 'No', false, p),
                  ],
                ),
                // Duration dropdown
                Row(
                  children: [
                    Text('Enter Retrying Duration',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700)),
                    const SizedBox(width: 10),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: _fieldFill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: p.retryDuration,
                          hint: const Text('Select',
                              style: TextStyle(fontSize: 13)),
                          items: ExamLocalProvider.retryOptions
                              .map((o) => DropdownMenuItem(
                                    value: o,
                                    child: Text(o,
                                        style: const TextStyle(
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: p.hasRetry
                              ? (v) => context
                                  .read<ExamLocalProvider>()
                                  .setRetryDuration(v)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Widget _retryChoice(
      BuildContext context, String label, bool value, ExamLocalProvider p) {
    final selected = p.hasRetry == value;
    return GestureDetector(
      onTap: () => context.read<ExamLocalProvider>().setHasRetry(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          border: Border.all(
              color:
                  selected ? AppColors.primaryColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: CustomScrollView(
        slivers: [
          const CustomMainHeader(),

          // Page title + Back
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exams / Final Examination',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add More Details',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Back',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Divider(height: 1)),

          // Form
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            sliver: Consumer<ExamLocalProvider>(
              builder: (context, p, _) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    _buildExamDetails(context, p),
                    _buildExamTerms(context, p),
                    _buildQuestions(context, p),
                    _buildRetrySettings(context, p),
                    const SizedBox(height: 8),

                    // Save button
                    Center(
                      child: Consumer<AddExamFirebaseProvider>(
                        builder: (context, fbProvider, _) {
                          final isLoading = fbProvider.addExamState == AppState.loading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : () => _onSave(context, p),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 48, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Save Final Examination',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSave(BuildContext context, ExamLocalProvider p) async {
    log("[AddFinalExamView] Starting validation for final exam...");
    
    final duration = p.selectedDuration;
    if (duration == null) {
      log("[AddFinalExamView] Validation failed: duration is null");
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Please select exam duration'),
      );
      return;
    }

    final totalMarksStr = p.totalMarkCtrl.text.trim();
    final passMarksStr = p.passMarkCtrl.text.trim();
    log("[AddFinalExamView] Marks entered: totalMarks='$totalMarksStr', passMarks='$passMarksStr'");
    if (totalMarksStr.isEmpty || passMarksStr.isEmpty) {
      log("[AddFinalExamView] Validation failed: total marks or pass marks fields are empty");
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Please enter total marks and pass marks'),
      );
      return;
    }

    final totalMarks = int.tryParse(totalMarksStr);
    final passMarks = int.tryParse(passMarksStr);
    if (totalMarks == null || passMarks == null) {
      log("[AddFinalExamView] Validation failed: totalMarks or passMarks could not be parsed to integers");
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Marks must be valid numbers'),
      );
      return;
    }

    if (passMarks > totalMarks) {
      log("[AddFinalExamView] Validation failed: passMarks ($passMarks) > totalMarks ($totalMarks)");
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Pass marks cannot be greater than total marks'),
      );
      return;
    }

    // Validate terms
    final terms = p.termCtrls
        .map((ctrl) => ctrl.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    log("[AddFinalExamView] Validated terms count: ${terms.length}");
    if (terms.isEmpty) {
      log("[AddFinalExamView] Validation failed: no terms provided");
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Please add at least one exam term'),
      );
      return;
    }

    // Validate questions
    final questions = <ExamQuestionModel>[];
    log("[AddFinalExamView] Validating questions...");
    for (int i = 0; i < p.questions.length; i++) {
      final q = p.questions[i];
      final qText = q.questionCtrl.text.trim();
      if (qText.isEmpty) {
        log("[AddFinalExamView] Validation failed: Question ${i + 1} has empty text");
        toastification.show(
          type: ToastificationType.warning,
          title: Text('Please enter text for question ${i + 1}'),
        );
        return;
      }

      final options = q.optionCtrls
          .map((ctrl) => ctrl.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      log("[AddFinalExamView] Question ${i + 1} options count: ${options.length}");
      if (options.length < 2) {
        log("[AddFinalExamView] Validation failed: Question ${i + 1} has less than 2 options");
        toastification.show(
          type: ToastificationType.warning,
          title: Text('Question ${i + 1} must have at least 2 non-empty options'),
        );
        return;
      }

      questions.add(ExamQuestionModel(
        question: qText,
        options: options,
        correctAnswer: q.correctAnswer,
      ));
    }

    if (p.hasRetry && p.retryDuration == null) {
      log("[AddFinalExamView] Validation failed: hasRetry is true but retryDuration is null");
      toastification.show(
        type: ToastificationType.warning,
        title: const Text('Please select a retry duration'),
      );
      return;
    }

    final exam = ExamModel(
      examId: '',
      courseId: courseId,
      moduleId: moduleId,
      duration: duration,
      totalMarks: totalMarks,
      passMarks: passMarks,
      terms: terms,
      questions: questions,
      hasRetry: p.hasRetry,
      retryDuration: p.retryDuration,
      isEnabled: true,
      createdAt: DateTime.now(),
    );

    log("[AddFinalExamView] Validation successful. Proceeding to save exam via AddExamFirebaseProvider...");
    final firebaseProvider = context.read<AddExamFirebaseProvider>();
    await firebaseProvider.handleAddExam(model: exam);

    if (context.mounted) {
      if (firebaseProvider.addExamState == AppState.success) {
        log("[AddFinalExamView] Exam saved successfully, clearing fields and popping screen.");
        p.clearFields();
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Exam added successfully'),
        );
        context.pop();
      } else {
        log("[AddFinalExamView] Failed to save exam: ${firebaseProvider.addExamError}");
        toastification.show(
          type: ToastificationType.error,
          title: Text(firebaseProvider.addExamError ?? 'Failed to save exam'),
        );
      }
    }
  }
}