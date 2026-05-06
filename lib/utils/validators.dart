class AppValidators {
  static String? validateFileName(String? value) {
    if (value == null || value.isEmpty) {
      return 'File name is required';
    }
    if (value.length < 3) {
      return 'File name must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'File name must be less than 100 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Description must be less than 500 characters';
    }
    return null;
  }

  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Comment cannot be empty';
    }
    if (value.length < 2) {
      return 'Comment must be at least 2 characters';
    }
    if (value.length > 1000) {
      return 'Comment must be less than 1000 characters';
    }
    return null;
  }

  static String? validateUserId(String? value) {
    if (value == null || value.isEmpty) {
      return 'User ID is required';
    }
    return null;
  }
}
