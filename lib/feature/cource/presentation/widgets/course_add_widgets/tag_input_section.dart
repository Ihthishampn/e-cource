import 'package:flutter/material.dart';

class TagInputSection extends StatelessWidget {
  const TagInputSection({
    super.key,
    required this.controller,
    required this.tags,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> tags;
  final VoidCallback onAdd;
  final void Function(String tag) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onAdd(),
                decoration: InputDecoration(
                  hintText: 'Type a tag and press +',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _AddTagButton(onTap: onAdd),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          _TagChipList(tags: tags, onRemove: onRemove),
        ],
      ],
    );
  }
}

class _AddTagButton extends StatelessWidget {
  const _AddTagButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 22),
      ),
    );
  }
}

class _TagChipList extends StatelessWidget {
  const _TagChipList({required this.tags, required this.onRemove});

  final List<String> tags;
  final void Function(String tag) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((tag) => _TagChip(tag: tag, onRemove: onRemove)).toList(),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag, required this.onRemove});

  final String tag;
  final void Function(String tag) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag,
              style:
                  const TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => onRemove(tag),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.close, color: Colors.white, size: 10),
            ),
          ),
        ],
      ),
    );
  }
}