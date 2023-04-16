class UserEntity{
  final String userName;

  UserEntity(this.userName);

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(json["userName"]);
  Map<String, dynamic> toJson() => {"userName": userName};
}
