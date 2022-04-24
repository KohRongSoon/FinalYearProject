class UserDataModel{
  String? uId;
  String? name;
  String? email;
  bool? isAdmin;

  UserDataModel({this.uId, this.name, this.email, this.isAdmin});

  //retrieved data
  factory UserDataModel.fromMap(map){
    return UserDataModel(
      uId: map['uId'],
      name: map['name'],
      email: map['email'],
      isAdmin: map['isAdmin'],
    );
  }

  //send data
  Map<String, dynamic> toMap(){
    return{
      'uId': uId,
      'name': name,
      'email': email,
      'isAdmin': false,
    };
  }
}