class District {
  late String name;
  late String notes;
  late int active;
  late int confirmed;
  late int migratedOther;
  late int deceased;
  late int recovered;

  District({
    required this.name,
    required this.notes,
    required this.active,
    required this.confirmed,
    required this.migratedOther,
    required this.deceased,
    required this.recovered,
  });

  District.fromJson(String key, Map<String, dynamic> value) {
    name = key;
    notes = value['notes'];
    active = value['active'];
    confirmed = value['confirmed'];
    migratedOther = value['migratedother'];
    deceased = value['deceased'];
    recovered = value['recovered'];
  }
}
