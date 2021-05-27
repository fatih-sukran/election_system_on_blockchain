import 'dart:convert';

class Address {
  final int id;
  final String neighborhood;
  final String district;
  final String country;
  // To Do: daha detaylandır adresi
  // To Do: Get metodlarını ekle
  Address(this.id, this.neighborhood, this.district, this.country);

  factory Address.fromJson(String json) {
    
    var decodedJson = jsonDecode(json);
    var id = decodedJson['id'];
    var neighborhood = decodedJson['neighborhood'];
    var district = decodedJson['district'];
    var country = decodedJson['country'];

    return Address(id, neighborhood, district, country);
  }

  String toJson() {
    return {
      'id': id,
      'neighborhood': neighborhood,
      'district': district,
      'country': country,
    }.toString();
  }
}
