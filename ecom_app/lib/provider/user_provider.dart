import 'package:ecom_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  /* constructor UserProvider khởi tạo với một đối tượng User mặc định.
     super:gọi đến constructor của lớp StateNotifier
   */
  UserProvider() : super (
      User(
          id: '',
          name: '',
          email: '',
          password: '',
         confirmPassword: '',
          phone: 0,
          address: '',
          avatar: '',
          token: '',
          city: '',
      )
  );

  /*Getter method dùng để truy xuất value từ object*/
  User? get user => state;

  /* cập nhật trạng thái User từ JSON */
  void setUser(String userJson){
    state = User.fromJson(userJson);
  }

  /* Xóa thông tin User để logout */
  void signOut() {
    state = null;
  }

  /*Hàm khởi tạo lại trạng thái user*/
  void recreateUserState({
    required int phone,
    required String address,
    required String avatar
  }) {
    if(state != null) {
      state = User(
          id: state!.id,
          name: state!.name,
          email: state!.email,
          password: state!.password,
        confirmPassword: state!.confirmPassword,
          phone: state!.phone,
          address: state!.address,
          avatar: state!.avatar,
          token: state!.token,
          city: state!.city,
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());