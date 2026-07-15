import 'package:flutter/material.dart';
import '../models/sensitivity_profile.dart';

class ProfileListTile extends StatelessWidget {
  final SensitivityProfile profile;
  final VoidCallback onDelete;
  final VoidCallback onRename;
  final VoidCallback onLoad;

  const ProfileListTile({
    super.key,
    required this.profile,
    required this.onDelete,
    required this.onRename,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(profile.name),
        subtitle: Text('${profile.deviceModel} - ${profile.playStyle}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onRename),
            IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: onDelete),
          ],
        ),
        onTap: onLoad,
      ),
    );
  }
}