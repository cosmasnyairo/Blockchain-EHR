class EhrDoctor {
  final String name;
  final String email;
  final String publickey;
  final String privatekey;
  final String doctorid;
  final String imageurl;
  final String gender;

  EhrDoctor({
    this.name,
    this.email,
    this.doctorid,
    this.imageurl,
    this.privatekey,
    this.publickey,
    this.gender,
  });

  Map toJson() => {
        'name': name,
        'email': email,
        'doctorid': doctorid,
      };
}
