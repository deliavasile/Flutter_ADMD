import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';
import 'models/library_item.dart';

void main() {
  runApp(const MyApp());
}

String status(LibraryItem i) {
  final b = i.borrower;
  final d = i.dueDate;
  if (b == null) return 'Available';
  return 'Borrowed by ${b.name} until '
      '${d == null ? 'N/A' : d.toIso8601String().split('T').first}';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const MyHomePage(title: 'Lab 2'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final users = [
      User(name: 'Ana', age: 21, email: 'ana@gmail.com'),
      User(name: 'Mihai', age: 18),
      User(name: 'Ioana'),
    ];

    final accounts = [
      BankAccount(holderName: 'Ana', balance: 1500.5, bankBranch: 'Revolut Bucuresti')
        ..initializeAccount('ROREV12345'),
      BankAccount(holderName: 'Mihai', bankBranch: 'BT Cluj')
        ..initializeAccount('ROBT12345'),
      BankAccount(holderName: 'Ioana', balance: 200),
    ];

    final now = DateTime.now();
    final due = now.add(const Duration(days: 14));

    final book1 = Book(
      title: 'Math',
      author: 'John Doe',
      publishDate: DateTime(2012, 5, 1),
      pageCount: 400,
      isbn: '3143',
    );
    final book2 = Book(title: 'History');
    final mag1 = Magazine(
      title: 'Vogue',
      publishDate: now.subtract(const Duration(days: 20)),
      issueNumber: 42,
      publisher: 'Vogue Fashion House',
    );
    final mag2 = Magazine(
      title: 'Cosmopolitan',
      author: 'Editorial Team',
      publishDate: now.subtract(const Duration(days: 10)),
    );

    final library = Library();
    for (final item in [book1, book2, mag1, mag2]) {
      library.addItem(item);
    }
    library.borrowItem(book1, users[0], due);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          const ListTile(title: Text('Users')),
          for (final u in users)
            ListTile(
              title: Text(u.name),
              subtitle: Text('${u.getDisplayAge()} | ${u.getDisplayEmail()}'),
            ),
          const Divider(),
          const ListTile(title: Text('Bank accounts')),
          for (final a in accounts)
            ListTile(
              title: Text(a.holderName),
              subtitle: Text(
                '${a.getDisplayNumber()}\n'
                'Branch: ${a.bankBranch ?? 'N/A'} | Balance: ${a.balance}',
              ),
              isThreeLine: true,
            ),
          const Divider(),
          const ListTile(title: Text('Library')),
          for (final i in library.items)
            ListTile(
              title: Text(i.title),
              subtitle: Text('${i.describe()}\n${status(i)}'),
              isThreeLine: true,
            ),
        ],
      ),
    );
  }
}