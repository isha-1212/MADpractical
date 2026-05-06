import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/index.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class FileDetailsScreen extends StatefulWidget {
  final String fileId;

  const FileDetailsScreen({required this.fileId, Key? key}) : super(key: key);

  @override
  State<FileDetailsScreen> createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<VersionProvider>().loadVersions(widget.fileId);
    context.read<CommentProvider>().selectFile(widget.fileId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(
      builder: (context, fileProvider, _) {
        final file = fileProvider.files
            .cast<FileModel?>()
            .firstWhere((f) => f?.id == widget.fileId, orElse: () => null);

        if (file == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('File Details')),
            body: const Center(child: Text('File not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(file.name),
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Versions'),
                Tab(text: 'Comments'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildInfoTab(file, context),
              _buildVersionsTab(),
              _buildCommentsTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTab(FileModel file, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('File Name', file.name),
                const SizedBox(height: 12),
                _buildInfoRow('File Type', file.fileType),
                const SizedBox(height: 12),
                _buildInfoRow('Version', 'v${file.latestVersion}'),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Created',
                  DateTimeHelper.formatDateTime(file.createdAt),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Last Updated',
                  DateTimeHelper.formatDateTime(file.updatedAt),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Status', file.isShared ? 'Shared' : 'Personal'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            file.description,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showShareDialog(context, file.id);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showEditDialog(context, file.id, file.description);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVersionsTab() {
    return Consumer<VersionProvider>(
      builder: (context, versionProvider, _) {
        final versions = versionProvider.getVersionsForFile(widget.fileId);
        return ListView.builder(
          itemCount: versions.length,
          itemBuilder: (context, index) {
            return VersionListTile(version: versions[index]);
          },
        );
      },
    );
  }

  Widget _buildCommentsTab() {
    return Consumer<CommentProvider>(
      builder: (context, commentProvider, _) {
        return Column(
          children: [
            Expanded(
              child: commentProvider.currentComments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'No comments yet',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: commentProvider.currentComments.length,
                      itemBuilder: (context, index) {
                        return CommentTile(
                          comment: commentProvider.currentComments[index],
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        commentProvider.addComment(
                          widget.fileId,
                          _commentController.text,
                        );
                        _commentController.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _showShareDialog(BuildContext context, String fileId) {
    final userController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter user ID to share with:'),
            const SizedBox(height: 16),
            TextField(
              controller: userController,
              decoration: InputDecoration(
                hintText: 'User ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (userController.text.isNotEmpty) {
                context.read<FileProvider>().shareFile(
                    fileId, userController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String fileId,
      String currentDescription) {
    final descController = TextEditingController(text: currentDescription);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FileProvider>().updateFile(
                fileId: fileId,
                description: descController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
