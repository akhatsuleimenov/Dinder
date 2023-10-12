class IndexService {
  IndexService._internal();

  // Store the instance
  static final IndexService _singleton = IndexService._internal();

  // Provide a way to access the instance
  static IndexService get instance => _singleton;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  // Function to reset the selectedIndex
  void logout() {
    _selectedIndex = 0;
  }

  // Function to update the selectedIndex
  void update(int index) {
    _selectedIndex = index;
  }
}
