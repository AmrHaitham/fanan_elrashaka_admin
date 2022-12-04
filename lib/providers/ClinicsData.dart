import 'package:fanan_elrashaka_admin/models/CategoriesModel.dart';
import 'package:fanan_elrashaka_admin/models/Clinic.dart';
import 'package:flutter/material.dart';
class ClinisData with ChangeNotifier{
  List<Clinic> _clinicsName = [];

  List<Clinic> get clinicsName => _clinicsName;

  void setClinicsName(List<Clinic> clinicsName){
    _clinicsName = clinicsName;
    notifyListeners();
  }

  List<Clinic> _clinicsService = [];

  List<Clinic> get clinicsService => _clinicsService;

  void setClinicsService(List<Clinic> clinicsService){
    _clinicsService = clinicsService;
    notifyListeners();
  }

  List<CategoriesModel> _categoriesModel = [];

  List<CategoriesModel> get categoriesModel => _categoriesModel;

  void setCategories(List<CategoriesModel> categoriesModel){
    _categoriesModel = categoriesModel;
    notifyListeners();
  }

}