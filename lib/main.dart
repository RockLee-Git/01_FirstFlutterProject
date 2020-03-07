import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
      home:RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list),onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions(){
    return ListView.builder(itemBuilder: (context,i){
      if(i.isOdd) return Divider(height: 3.0,color: Colors.black,);

      final index = i ~/ 2;
      if (index >= _suggestions.length){
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    });
  }

  Widget _buildRow(WordPair suggestion) {

    final bool alreadySaved = _saved.contains(suggestion);

    return ListTile(
      title: Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(suggestion);
          }else{
            _saved.add(suggestion);
          }
        });
      },
    );
  }


  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final Iterable<ListTile> titles = _saved.map(
                  (WordPair savedWordPair){
                return ListTile(
                  title: Text(
                    savedWordPair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );
          final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: titles
          ).toList(); 
          
          return Scaffold(
            appBar: AppBar(title: const Text('Saved Suggestions'),),
            body: ListView(children: divided,),
          );
        }
      ),
    );
  }
}
