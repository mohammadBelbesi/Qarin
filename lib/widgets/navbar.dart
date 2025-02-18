import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart'; // Import LocaleProvider

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Navbar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          // Add logic for menu button if needed
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language), // Language change icon
          onPressed: () {
            _showLanguageDialog(context); // Show language selection dialog
          },
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  _changeLanguage(context, const Locale('en'));
                },
              ),
              ListTile(
                title: const Text('Arabic'),
                onTap: () {
                  _changeLanguage(context, const Locale('ar'));
                },
              ),
              ListTile(
                title: const Text('Hebrew'),
                onTap: () {
                  _changeLanguage(context, const Locale('he'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    Navigator.of(context).pop(); // Close the dialog
    Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
