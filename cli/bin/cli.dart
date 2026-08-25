import 'dart:io';
import 'package:http/http.dart' as http;
const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } 
  else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } 
  else if (arguments.first == 'wikipedia') {
    // Add this new block:
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null; //take the rest of arguments list minus the first element
    //list is zero indexed
    searchWikipedia(inputArgs);
  } 
  else {
    printUsage();
  }
}

void searchWikipedia(List<String>? arguments) async { // ? to arguments type means arguments list can be null
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    // Read input without the `?? ''` fallback.
    final inputFromStdin = stdin.readLineSync();
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided. Exiting.');
      return; // Exit the function if there's no valid input.
    }
    articleTitle = inputFromStdin;
  } else {
    // Otherwise, join the arguments into a single string.
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');

  // Call the API and await the result.
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent); // Print the full article response (raw JSON for now)
}

void printUsage() { // Add this new function
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
  );
}

//Future = async function
Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );
  final response = await http.get(url); // Make the HTTP request

  if (response.statusCode == 200) {
    return response.body; // Return the response body if successful
  }

  // Return an error message if the request failed
  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
}