import 'dart:async';
import 'package:api_marvel/controllers/controller-view.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class HeroPage extends StatefulWidget {  
  const HeroPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeroPage(); 
}

class _HeroPage extends State<HeroPage> {
  bool _carregando = false; 
  late Data _datawrapper;
  HomeController repository = HomeController();
  List<String> nomeDescricao = []; 
  Widget customSearchBar = const Text('Marvel');
  Icon customIcon = const Icon(Icons.search);
  final TextEditingController _filter = TextEditingController();
  Timer? _timerInputSearch;


  @override
  void initState() {
    super.initState();
    _init();
    _registerListenerInputSearch();
  }

  void _registerListenerInputSearch() {
    _filter.addListener(_changeInputSearch);
  }

  Future<void> _init() async {
    setState(() {
      _carregando = true;
    });
    final result = await repository.getHeroes();
    setState(() {
      _datawrapper = result;
      _carregando = false;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions :[
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.close);
                  customSearchBar = TextField(
                    controller: _filter,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Procure...'
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Herois');
                  _filter.clear();
                }
              });        
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
      ),
      body: _constroiBody(),
    );
  }


  Widget _constroiBody() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: _datawrapper.results.length,
      itemBuilder: (context, index) => _buildText(index),
    );
  }
  
  Widget _buildText(int index) {
    final heroi = _datawrapper.results[index];

    return ListTile(
      leading: _constroiImagem(heroi),
      title: Text(heroi.name),
      subtitle: Text(heroi.description),
    );
  }
  
  Widget _constroiImagem(heroi) {
    return Image.network('${heroi.thumbnail.path}.${heroi.thumbnail.extension}');
  }
  
  void _changeInputSearch() async {
    if (_timerInputSearch != null) {
      _timerInputSearch!.cancel();
    } 
    _timerInputSearch = Timer(const Duration(milliseconds: 700), () async {
      if (_filter.text.isEmpty) {
        final result2 = await repository.getHeroes();
        setState(() {
          _datawrapper = result2;
        });
      }  else {
        final result = await repository.getHeroes(_filter.text);
        setState(() {
          _datawrapper = result;
        });
      }
    });
  }
}