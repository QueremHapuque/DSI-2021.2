// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

enum ViewType { grid, list }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  ViewType _viewType = ViewType.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Gerador de Nomes Aleatórios'), actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Favoritos',
          )
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: _pushSwitch,
          child:
              Icon(_viewType == ViewType.grid ? Icons.list : Icons.grid_view),
        ),
        body: _getBody());
  }

  _pushSwitch() {
    if (_viewType == ViewType.grid) {
      _viewType = ViewType.list;
    } else {
      _viewType = ViewType.grid;
    }
    setState(() {});
  }

  _getBody() {
    if (_viewType == ViewType.list) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          const pair = WordPair;

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: SizedBox(
              width: 70,
              child: Row(
                children: [
                  Icon(
                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved ? Colors.red : null,
                    semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                  ),
                  IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _suggestions.remove(pair);
                    _saved.remove(pair);
                  });
                })
                ],
              ),
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      );
    } else {
      return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[i]);

          return ListTile(
            title: Center(
                child: Text(
              _suggestions[i].asPascalCase,
              style: _biggerFont,
            )),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[i]);
                } else {
                  _saved.add(_suggestions[i]);
                }
              });
            },
          );
        },
      );
    }
  }

  _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favoritos'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  _pushDelete(WordPair pair) {
    () {
      setState(() {
        _suggestions.remove(pair);
        _saved.remove(pair);
      });
    };
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}
