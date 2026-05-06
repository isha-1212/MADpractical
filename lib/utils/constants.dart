class AppConstants {
  static const String appName = 'Smart File Sharing';
  static const String appVersion = '1.0.0';

  static const List<String> fileTypes = [
    'PDF',
    'DOCX',
    'XLSX',
    'PPTX',
    'TXT',
    'IMAGE',
    'OTHER',
  ];

  static const Map<String, String> fileTypeExtensions = {
    'PDF': '.pdf',
    'DOCX': '.docx',
    'XLSX': '.xlsx',
    'PPTX': '.pptx',
    'TXT': '.txt',
    'IMAGE': '.jpg, .png, .gif',
    'OTHER': 'other',
  };

  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
}
