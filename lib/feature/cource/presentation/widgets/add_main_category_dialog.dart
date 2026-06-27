import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'create_main_category_dialog.dart';

class AddMainCategoryDialog extends StatefulWidget {
  const AddMainCategoryDialog({super.key});

  @override
  State<AddMainCategoryDialog> createState() => _AddMainCategoryDialogState();
}

class _AddMainCategoryDialogState extends State<AddMainCategoryDialog> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CourseFirebaseProvider>().handleFetchMainCategory();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Main Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Search
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      final provider = context.read<CourseFirebaseProvider>();

                      if (value.trim().isEmpty) {
                        provider.clearSearch();
                      } else {
                        provider.handleSearchCat(q: value.trim());
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List
                  SizedBox(
                    height: 350,
                    child: Consumer<CourseFirebaseProvider>(
                      builder: (context, value, child) {
                        final isSearching = searchController.text
                            .trim()
                            .isNotEmpty;

                        final categories = isSearching
                            ? value.searchList
                            : value.mcList;

                        final isLoading = isSearching
                            ? value.searchCategoryState == AppState.loading
                            : value.getCategoryState == AppState.loading;

                        if (isLoading) {
                          return Center(
                            child: SpinKitWaveSpinner(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }

                        if (categories.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  isSearching
                                      ? 'No categories found'
                                      : 'No categories added',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return _buildCategoryItem(
                              title: category.name,
                              imageUrl: category.image,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const CreateMainCategoryDialog(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Add New Category',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({required String title, required String imageUrl}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: (_, __) => Center(
                child: SpinKitPianoWave(
                  color: AppColors.primaryColor,
                  size: 40,
                ),
              ),
              errorWidget: (_, __, ___) => const Icon(Icons.image),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
