// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/controllers/home_controller.dart';

import 'package:http/http.dart' as http;

import '../../province_model.dart';

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    Key? key,
    required this.tipe
  }) : super(key: key);

  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        label: tipe == "asal" ? "Provinsi Asal" : "Provinsi Tujuan",
        showClearButton: true,
        onFind: (String? filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");

          try{

            final response = await http.get(
              url, 
              headers: {
                "key": "798d3f72a1cd6bce4b684aeed186f58a", 
              }
            );

            var data = json.decode(response.body);

            var listAllProvince = data["rajaongkir"]["results"];                
            
            var models = Province.fromJsonList(listAllProvince);
            return models;

          }catch(err){
            return List<Province>.empty();
          }

        },
        onChanged: (prov){
          if(prov != null){
            print(prov.province);

            if(tipe == "asal"){
              controller.hiddenKotaAsal.value = false;
              controller.provAsalId.value = int.parse(prov.provinceId!);
            }else{
              controller.hiddenKotaTujuan.value = false;
              controller.provTujuanId.value = int.parse(prov.provinceId!);
            }

          }else{
            print("tidak memiliki nilai apapun");

            if(tipe == "asal"){
              controller.hiddenKotaAsal.value = true;
            controller.provAsalId.value = 0;
            }else{
              controller.hiddenKotaTujuan.value = true;
              controller.provTujuanId.value = 0;
            }

            
          }
        }, 
        popupItemBuilder: (context, item, isSelected){
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15, 
              vertical: 5
            ),
            child: Text(
              "${item.province}", 
              style: TextStyle(
                fontSize: 18, 

              ),
            ),
          );
        },
        itemAsString: (item) => item!.province!,
        showSearchBox: true,
      ),
    );
  }
}
