import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/sensitivity_profile.dart';
import '../widgets/profile_list_tile.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profiles = provider.profiles;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Profiles')),
      body: profiles.isEmpty
          ? const Center(child: Text('No saved profiles', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (ctx, i) {
                return ProfileListTile(
                  profile: profiles[i],
                  onDelete: () => provider.deleteProfile(profiles[i].id),
                  onRename: () => _showRenameDialog(context, profiles[i], provider),
                  onLoad: () => provider.loadProfile(profiles[i]),
                );
              },
            ),
    );
  }

  void _showRenameDialog(BuildContext context, SensitivityProfile profile, ProfileProvider provider) {
    final controller = TextEditingController(text: profile.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename Profile'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.renameProfile(profile.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}