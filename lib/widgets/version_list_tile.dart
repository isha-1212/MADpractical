import 'package:flutter/material.dart';
import '../models/file_version_model.dart';
import '../utils/datetime_helper.dart';

class VersionListTile extends StatelessWidget {
  final FileVersionModel version;

  const VersionListTile({required this.version});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.indigo.withOpacity(0.1),
        ),
        child: Center(
          child: Text(
            'v${version.versionNumber}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      title: Text('Version ${version.versionNumber}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('By: ${version.createdBy}'),
          Text(DateTimeHelper.formatDateTime(version.createdAt)),
        ],
      ),
      trailing: version.changeDescription != null
          ? Tooltip(
              message: version.changeDescription,
              child: const Icon(Icons.info_outline),
            )
          : null,
    );
  }
}
