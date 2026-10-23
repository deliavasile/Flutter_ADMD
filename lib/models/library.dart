import 'library_item.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> _items = [];

  List<LibraryItem> get items => List.unmodifiable(_items);

  bool addItem(LibraryItem item) {
    if (item.title.trim().isEmpty || _items.contains(item)) return false;
    _items.add(item);
    return true;
  }

  List<LibraryItem> searchByTitle(String? query) {
    final q = query?.trim().toLowerCase();
    if (q == null || q.isEmpty) return [];
    return _items.where((i) => i.title.toLowerCase().contains(q)).toList();
  }

  List<LibraryItem> getItemsByAuthor(String? author) {
    final q = author?.trim().toLowerCase();
    if (q == null || q.isEmpty) return [];
    return _items
        .where((i) => i.author?.toLowerCase().contains(q) ?? false)
        .toList();
  }

  List<LibraryItem> getRecentItems({int days = 365}) {
    final limit = DateTime.now().subtract(Duration(days: days));
    final recent = _items.where((i) {
      final d = i.publishDate;
      return d != null && d.isAfter(limit);
    }).toList();
    recent.sort((a, b) => (b.publishDate ?? DateTime(0))
        .compareTo(a.publishDate ?? DateTime(0)));
    return recent;
  }

  bool borrowItem(LibraryItem item, User user, DateTime dueDate) {
    if (!_items.contains(item) || item.isBorrowed) return false;
    item.borrower = user;
    item.dueDate = dueDate;
    return true;
  }

  bool returnItem(LibraryItem item) {
    if (!item.isBorrowed) return false;
    item.borrower = null;
    item.dueDate = null;
    return true;
  }
}