///
/// Created by Sunil Kumar on 29-04-2020 08:04 AM.
///
enum UserType { vendor, user }

extension UserTypeToString on UserType {
  String get string {
    if (this == UserType.vendor)
      return 'res';
    else
      return 'user';
  }
}
