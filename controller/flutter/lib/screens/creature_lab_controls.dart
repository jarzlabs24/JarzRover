import 'package:flutter/material.dart';

class CreatureLabControls extends StatelessWidget {
  final Map<String, dynamic> state;
  final void Function(String command) sendCommand;

  const CreatureLabControls({
    required this.state,
    required this.sendCommand,
    super.key,
  });

  bool _flag(String name) => state[name] == true || state[name] == 'true';

  @override
  Widget build(BuildContext context) {
    final bool watching = _flag('watching');
    final bool objectFound = _flag('objectFound');
    final bool generating = _flag('generating');
    final String message = state['message']?.toString() ??
        'Creature Lab is connecting to the rover…';

    return Material(
      color: const Color(0xD9140D2D),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xF225174A),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF8B7CF6), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 24),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: Color(0xFFFFD54F)),
                          SizedBox(width: 10),
                          Text(
                            'Creature Lab Remote',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: objectFound
                              ? const Color(0xFFFFC107)
                              : const Color(0x3326C6DA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          objectFound ? 'Object found! $message' : message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: objectFound
                                ? const Color(0xFF24123A)
                                : Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (generating) ...[
                        const SizedBox(height: 14),
                        const LinearProgressIndicator(
                          color: Color(0xFFFFD54F),
                          backgroundColor: Color(0x338B7CF6),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionButton(
                            label: 'Learn Empty Area',
                            icon: Icons.center_focus_strong,
                            enabled: _flag('canLearn'),
                            onPressed: () => sendCommand('CREATURE_LEARN_AREA'),
                          ),
                          _ActionButton(
                            label: watching
                                ? 'Stop Watching'
                                : 'Watch for Objects',
                            icon:
                                watching ? Icons.stop_circle : Icons.visibility,
                            enabled: _flag('canWatch'),
                            onPressed: () =>
                                sendCommand('CREATURE_TOGGLE_WATCHING'),
                          ),
                          _ActionButton(
                            label: objectFound
                                ? 'Take Picture Now'
                                : 'Take Picture',
                            icon: Icons.camera_alt,
                            emphasized: objectFound,
                            enabled: _flag('canTakePhoto'),
                            onPressed: () => sendCommand('CREATURE_TAKE_PHOTO'),
                          ),
                          if (objectFound)
                            _ActionButton(
                              label: 'Not Yet',
                              icon: Icons.pause_circle,
                              enabled: true,
                              onPressed: () => sendCommand('CREATURE_NOT_YET'),
                            ),
                          _ActionButton(
                            label: 'Create Creature',
                            icon: Icons.auto_awesome,
                            enabled: _flag('canCreate'),
                            onPressed: () => sendCommand('CREATURE_CREATE'),
                          ),
                          _ActionButton(
                            label: 'Retake',
                            icon: Icons.refresh,
                            enabled: _flag('canRetake'),
                            onPressed: () => sendCommand('CREATURE_RETAKE'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final bool emphasized;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(label, textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              emphasized ? const Color(0xFFFFC107) : const Color(0xFF6D5CE7),
          foregroundColor: emphasized ? const Color(0xFF24123A) : Colors.white,
          disabledBackgroundColor: const Color(0xFF4A4261),
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
