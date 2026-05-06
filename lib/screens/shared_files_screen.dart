import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class SharedFilesScreen extends StatelessWidget {
  const SharedFilesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Files'),
        elevation: 0,
      ),
      body: Consumer<FileProvider>(
        builder: (context, fileProvider, _) {
          fileProvider.showSharedFiles();
          final sharedFiles = fileProvider.filteredFiles;

          return sharedFiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No shared files',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: sharedFiles.length,
                  itemBuilder: (context, index) {
                    final file = sharedFiles[index];
                    return FileCard(
                      file: file,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/file-details',
                          arguments: file.id,
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
