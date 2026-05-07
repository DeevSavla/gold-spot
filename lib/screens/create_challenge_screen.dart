part of '../main.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({
    super.key,
    required this.onClose,
    required this.onSubmit,
    required this.onDone,
  });

  final VoidCallback onClose;
  final Future<String> Function(CreateChallengePayload payload) onSubmit;
  final VoidCallback onDone;

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _category = 'Endurance';
  int _duration = 30;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleLaunch() async {
    if (_nameController.text.trim().isEmpty) {
      _showDialog('Enter a challenge name');
      return;
    }
    if (_duration < 1) {
      _showDialog('Duration must be at least 1 day');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final String joinCode = await widget.onSubmit(
        CreateChallengePayload(
          name: _nameController.text.trim(),
          category: _category,
          duration: _duration,
          description: _descriptionController.text.trim(),
        ),
      );

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppPalette.surface,
            title: const Text(
              'Challenge Created!',
              style: TextStyle(color: AppPalette.text),
            ),
            content: Text(
              'Your challenge is live.\n\nShare this join code with your friends or clients:\n\n$joinCode',
              style: const TextStyle(color: AppPalette.mutedText, height: 1.5),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it!'),
              ),
            ],
          );
        },
      );

      widget.onDone();
    } on ApiException catch (error) {
      _showDialog(error.message);
    } catch (_) {
      _showDialog('Failed to create challenge.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showDialog(String message) async {
    if (!mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppPalette.surface,
          content: Text(message, style: const TextStyle(color: AppPalette.text)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
      <String, dynamic>{'name': 'Endurance', 'icon': Icons.directions_run},
      <String, dynamic>{'name': 'Strength', 'icon': Icons.fitness_center},
      <String, dynamic>{'name': 'Mobility', 'icon': Icons.self_improvement},
      <String, dynamic>{'name': 'Nutrition', 'icon': Icons.restaurant},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: AppPalette.text),
                ),
                const Text(
                  'NEW CHALLENGE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppPalette.text,
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'ARCHITECT MODE',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppPalette.text,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Design a challenge to push your community.',
              style: TextStyle(fontSize: 14, color: AppPalette.mutedText),
            ),
            const SizedBox(height: 22),
            _AuthField(
              label: 'CHALLENGE NAME',
              controller: _nameController,
              hintText: 'e.g., 30 Days of Iron',
            ),
            const SizedBox(height: 22),
            const Text(
              'CATEGORY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppPalette.mutedText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((Map<String, dynamic> cat) {
                final bool isSelected = _category == cat['name'];
                return GestureDetector(
                  onTap: () => setState(() => _category = cat['name'] as String),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppPalette.primary : AppPalette.surfaceAlt,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppPalette.primary : AppPalette.border,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          cat['icon'] as IconData,
                          color: isSelected ? Colors.black : AppPalette.text,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['name'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.black : AppPalette.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            const Text(
              'DURATION (DAYS)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppPalette.mutedText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPalette.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppPalette.border),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => setState(() => _duration = _duration > 1 ? _duration - 1 : 1),
                    style: IconButton.styleFrom(backgroundColor: AppPalette.surface),
                    icon: const Icon(Icons.remove, color: AppPalette.text),
                  ),
                  Expanded(
                    child: Text(
                      '$_duration',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppPalette.text,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _duration += 1),
                    style: IconButton.styleFrom(backgroundColor: AppPalette.surface),
                    icon: const Icon(Icons.add, color: AppPalette.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _AuthField(
              label: 'DESCRIPTION & RULES',
              controller: _descriptionController,
              hintText: 'Describe the mission and rules for participants...',
              maxLines: 4,
            ),
            const SizedBox(height: 22),
            const Text(
              'COVER IMAGE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppPalette.mutedText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppPalette.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.15),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_photo_alternate, color: AppPalette.mutedText),
                    SizedBox(height: 8),
                    Text(
                      'UPLOAD IMAGE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppPalette.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        decoration: const BoxDecoration(
          color: AppPalette.background,
          border: Border(top: BorderSide(color: AppPalette.border)),
        ),
        child: _PrimaryButton(
          label: _isSubmitting ? 'LAUNCHING...' : 'LAUNCH CHALLENGE',
          onTap: _isSubmitting ? () {} : _handleLaunch,
        ),
      ),
    );
  }
}

