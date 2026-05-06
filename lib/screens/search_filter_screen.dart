import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFileType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search files...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        child: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Filter by File Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: AppConstants.fileTypes
                  .map(
                    (type) => FilterChip(
                      label: Text(type),
                      selected: _selectedFileType == type,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFileType = selected ? type : null;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Consumer<FileProvider>(
              builder: (context, fileProvider, _) {
                return fileProvider.filteredFiles.isEmpty
                    ? Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: fileProvider.filteredFiles.length,
                        itemBuilder: (context, index) {
                          final file = fileProvider.filteredFiles[index];
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
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    final fileProvider = context.read<FileProvider>();

    if (_searchController.text.isNotEmpty) {
      fileProvider.searchFiles(_searchController.text);
    } else if (_selectedFileType != null) {
      fileProvider.filterByFileType(_selectedFileType!);
    } else {
      fileProvider.clearFilter();
    }

    setState(() {});
  }

  void _clearFilters() {
    _searchController.clear();
    _selectedFileType = null;
    context.read<FileProvider>().clearFilter();
    setState(() {});
  }
}
