import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/index.dart';
import 'providers/index.dart';
import 'screens/index.dart';
import 'services/index.dart';
import 'utils/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = LocalStorageService();
  await storageService.initialize();

  final fileService = FileService(storageService);
  final commentService = CommentService(storageService);
  final conflictService = ConflictResolutionService(storageService);
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FileProvider(fileService, apiService)),
        ChangeNotifierProvider(create: (_) => CommentProvider(commentService)),
        ChangeNotifierProvider(
            create: (_) => VersionProvider(conflictService)),
        ChangeNotifierProvider(
            create: (_) => SyncProvider(apiService, storageService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      routes: {
        '/file-list': (context) => const FileListScreen(),
        '/file-upload': (context) => const FileUploadScreen(),
        '/file-details': (context) {
          final fileId = ModalRoute.of(context)!.settings.arguments as String;
          return FileDetailsScreen(fileId: fileId);
        },
        '/shared-files': (context) => const SharedFilesScreen(),
        '/search-filter': (context) => const SearchFilterScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FileListScreen(),
    SharedFilesScreen(),
    SearchFilterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SyncProvider>(
        builder: (context, syncProvider, _) {
          return Stack(
            children: [
              _screens[_currentIndex],
              if (syncProvider.syncStatus != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: syncProvider.isSyncing
                          ? Colors.orange
                          : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            syncProvider.syncStatus!,
                            style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ),
                        if (syncProvider.isSyncing)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'My Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Shared',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
