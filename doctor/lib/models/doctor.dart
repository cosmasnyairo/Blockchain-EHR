class EhrDoctor {
  final String name;
  final String email;
  final String publickey;
  final String privatekey;
  final String hospital;
  final String doctorid;
  final String imageurl;
  final String location;

  EhrDoctor({
    this.name,
    this.email,
    this.doctorid,
    this.hospital,
    this.imageurl,
    this.location,
    this.privatekey,
    this.publickey,
  });

  Map toJson() => {
        'name': name,
        'email': email,
        'doctorid': doctorid,
        'hospital': hospital,
        'location': location
      };
}
