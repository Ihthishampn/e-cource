import 'package:e_cource/feature/lesson/presentation/provider/lesson_provider.dart';
import 'package:e_cource/feature/module/data/model/module_model.dart';
import 'package:e_cource/feature/module/presentation/provider/module_provider.dart';
import 'package:e_cource/feature/module/presentation/widgets/cutom_module_dilogue.dart';
import 'package:e_cource/feature/module/presentation/widgets/module_card.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/button_with_icon.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_cource/feature/exam/presentation/provider/add_exam_firebase_provider.dart';

class CourseContentsWidget extends StatefulWidget {
  final String courseId;

  const CourseContentsWidget({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseContentsWidget> createState() => _CourseContentsWidgetState();
}

class _CourseContentsWidgetState extends State<CourseContentsWidget> {
  final TextEditingController modulenameController = TextEditingController();
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final moduleProvider = context.read<ModuleProvider>();
    final lessonProvider = context.read<LessonProvider>();

    moduleProvider.clear();
    lessonProvider.clear();

    await Future.wait([
      moduleProvider.handleFetch(widget.courseId),
      lessonProvider.handleGetLesson(widget.courseId),
      context.read<AddExamFirebaseProvider>().handleFetchExams(courseId: widget.courseId, moduleId: ''),
    ]);
  });
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Modules",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ButtonWithIcon(
                name: "Add new Module",
                icon: Icons.add,
                ontap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return Consumer<ModuleProvider>(
                        builder: (context, provider, child) {
                          return CustomModuleDialog(
                            title: "Add Module",
                            fieldHints: const ["Module Name"],
                            controllers: [modulenameController],
                            buttonText:
                                provider.addMpoduleState == AppState.loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Add"),
                            onAddPressed: () async {
                              if (modulenameController.text.trim().isEmpty) {
                                showToast(
                                  msg: "Module name can't be empty",
                                );
                                return;
                              }

                              final model = ModuleModel(
                                moduleId: "",
                                courseId: widget.courseId,
                                moduleName: modulenameController.text.trim(),
                                createdAt: DateTime.now(),
                              );

                              await provider.handleAddModule(model);

                              if (!mounted) return;

                              if (provider.addMpoduleState ==
                                  AppState.success) {
                                modulenameController.clear();
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                showToast(msg: "Module Added");
                              } else {
                                showToast(
                                  msg: provider.addModuleerror ??
                                      "Something went wrong",
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          Consumer<ModuleProvider>(
            builder: (context, provider, child) {
              if (provider.fetchpoduleState == AppState.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (provider.fetchpoduleState == AppState.error) {
                return Center(
                  child: Text(
                    provider.fetchModuleerror ?? "Something went wrong",
                  ),
                );
              }

              if (provider.moduleList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No modules found"),
                  ),
                );
              }

              return Column(
                children: provider.moduleList.map((module) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ModuleCard(module: module),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}