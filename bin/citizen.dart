import 'address.dart';

class Citizen {
  final int cardId;
  final String name;
  final String surname;
  final int birthday;
  final Address address;

  Citizen(this.cardId, this.name, this.surname, this.birthday, this.address);

  factory Citizen.fromCitizen(Citizen citizen) {
    return Citizen(citizen.cardId, citizen.name, citizen.surname,
        citizen.birthday, citizen.address);
  }

  int get age {
    var birth = DateTime.fromMillisecondsSinceEpoch(birthday);
    var currentDate = DateTime.now();
    var age = currentDate.year - birth.year;
    var month1 = currentDate.month;
    var month2 = birth.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birth.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String toJson() {
    return {
      'cardId': cardId,
      'name': name,
      'surname': surname,
      'birthday': birthday,
      'address': address.toJson(),
    }.toString();
  }
}
