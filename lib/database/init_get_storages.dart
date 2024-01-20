// import '/utils/_utils_index.dart';
// import 'package:get_storage/get_storage.dart';

// class LocalStorageBox {
//   static const tag = 'LocalStorageBox';

//   static Future<List<bool>> init() async {
//     return await Future.wait([
//       ...[
//         LocalStorage.appBox,
//         LocalStorage.themeBox,
//         LocalStorage.userBox,
//         LocalStorage.sessionBox,
//         LocalStorage.auctionBox,
//       ].map((boxName) => initBox(boxName)).toList(),
//     ]).then((value) {
//       logger.f('all inits : $value', tag: tag);
//       return value;
//     }).then((value) => value);
//   }

//   static Future<bool> initBox(String boxName) async {
//     return await GetStorage.init(boxName).then((value) {
//       logger.f('init $boxName : ${GetStorage(boxName).getKeys()}', tag: tag);
//       return value;
//     });
//   }
// }

// class LocalStorage {
//   static const String appBox = 'appBox';
//   static const String themeBox = 'themeBox';
//   static const String userBox = 'userBox';
//   static const String sessionBox = 'sessionBox';
//   static const String auctionBox = 'auctionBox';
// }
