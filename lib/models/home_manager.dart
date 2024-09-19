import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {

  HomeManager() {
    _loadSections();
  }

  final List<Section> _sections = [];

  List<Section> _editingSections = [];

  bool editing = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot){
      _sections.clear();
      for(final DocumentSnapshot document in snapshot.docs){
        _sections.add(Section.fromDocument(document));
      }
     notifyListeners();
    });
  }

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

  List<Section> get sections {
    if(editing)
      return _editingSections;
    else
      return _sections;
  }

  void enterEditing(){
    editing = true;

    _editingSections = _sections.map((s)=> s.clone()).toList();

    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;

    // Valida todas as seções
    for (final section in _editingSections) {
      if (!section.valid()) {
        valid = false;
      }
    }

    // Se alguma seção for inválida, retorna sem salvar
    if (!valid) return;

    for( final section in _editingSections){
      await section.save();
    }



    editing = false;
    notifyListeners();
  }

  void discartEditing(){
    editing = false;
    notifyListeners();
  }
}