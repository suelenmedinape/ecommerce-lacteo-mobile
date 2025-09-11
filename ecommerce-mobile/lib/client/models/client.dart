class Client {
  final String name;
  final String email;
  final String? phone;
  final Address? address;
  final String? cpf;

  Client({
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.cpf,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      cpf: json['cpf'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
    );
  }
}

class Address {
  final int id;
  final String street;
  final String number; // 🔹 String para evitar parse
  final String city;
  final String neighborhood;
  final String state;

  Address({
    required this.id,
    required this.street,
    required this.number,
    required this.city,
    required this.neighborhood,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      number: json['number'].toString(),
      city: json['city'],
      neighborhood: json['neighborhood'],
      state: json['state'],
    );
  }
}
