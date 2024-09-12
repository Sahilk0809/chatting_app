class UserModal {
  late String name, email, token, image;

  UserModal({
    required this.name,
    required this.email,
    required this.token,
    required this.image,
  });

  factory UserModal.fromMap(Map m1) {
    return UserModal(
      name: m1['name'],
      email: m1['email'],
      token: m1['token'],
      image: m1['image'],
    );
  }
}
