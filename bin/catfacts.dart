import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('Welcome to Cat Facts App!');
  final catFactsApp = CatFactsApp();
  await catFactsApp.run();
}

class CatFactsApp {
  final List<String> favoriteFacts = [];
  final Map<String, String> languages = {
    '1': 'English',
    '2': 'Spanish',
    '3': 'French',
    '4': 'German',
    '5': 'Italian',
  };

  Future<void> run() async {
    String? selectedLanguage = await selectLanguage();
    if (selectedLanguage == null) return;

    while (true) {
      try {
        final fact = await fetchCatFact(selectedLanguage!);
        print('\n Cat Fact: $fact\n');

        final choice = await getMenuChoice();

        switch (choice) {
          case '1':
            favoriteFacts.add(fact);
            print('Fact added to favorites!');
            break;
          case '2':
            break;
          case '3':
            displayFavoriteFacts();
            break;
          case '4':
            favoriteFacts.clear();
            print('Favorites list cleared!');
            break;
          case '5':
            selectedLanguage = await selectLanguage();
            if (selectedLanguage == null) return;
            break;
          case '6':
            print('Goodbye!');
            return;
          default:
            print('Invalid choice. Please try again.');
        }
      } catch (e) {
        print('Error: $e');
        print('Please try again.');
      }
    }
  }

  Future<String?> selectLanguage() async {
    print('\nSelect a language:');
    languages.forEach((key, value) => print('$key. $value'));
    print('6. Exit');

    final input = stdin.readLineSync();
    if (input == '6') {
      print('Goodbye!');
      return null;
    }

    return languages[input]?.toLowerCase() ?? 'english';
  }

  Future<String> fetchCatFact(String language) async {
    final url = Uri.parse('https://catfact.ninja/fact?lang=$language');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['fact'];
    } else {
      throw Exception('Failed to load cat fact');
    }
  }

  Future<String> getMenuChoice() async {
    print('What would you like to do?');
    print('1. Add to favorites and get next fact');
    print('2. Get next fact');
    print('3. View favorites');
    print('4. Clear favorites');
    print('5. Change language');
    print('6. Exit');

    return stdin.readLineSync() ?? '';
  }

  void displayFavoriteFacts() {
    if (favoriteFacts.isEmpty) {
      print('You have no favorite facts yet.');
      return;
    }

    print('\n Your Favorite Cat Facts:');
    for (var i = 0; i < favoriteFacts.length; i++) {
      print('${i + 1}. ${favoriteFacts[i]}');
    }
  }
}