// import 'dart:convert';
// import 'dart:io';
// import 'package:action_tds/services/log_services.dart';
// import 'package:action_tds/utils/size_utils.dart';
// import 'package:action_tds/utils/text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// import '../app/routes/app_pages.dart';

// class ErrorLogController extends GetxController {
//   final selectedItems = <String>[].obs;
//   setSelectedItems(List<String> value) {
//     selectedItems.value = value;
//     update();
//   }

//   removeSelectedItems(FileSystemEntity value) {
//     selectedItems.remove(value.path);
//     update();
//   }

//   addSelectedItems(FileSystemEntity value) {
//     selectedItems.add(value.path);
//     update();
//   }

//   clearSelectedItems() {
//     selectedItems.clear();
//     update();
//   }
// }

// class ErrorLogListScreen extends StatefulWidget {
//   final FileSystemEntity? rootEntity;
//   ErrorLogListScreen({super.key, this.rootEntity});

//   @override
//   State<ErrorLogListScreen> createState() => _ErrorLogListScreenState();
// }

// class _ErrorLogListScreenState extends State<ErrorLogListScreen> {
//   final controller = Get.put(ErrorLogController());

//   @override
//   void dispose() {
//     // controller.clearSelectedItems();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<FileSystemEntity>>(
//         future: _getErrorLogFiles(),
//         builder: (context, snapshot) {
//           return GetBuilder<ErrorLogController>(builder: (ctr) {
//             return Scaffold(
//               appBar: AppBar(
//                 title: titleLargeText(
//                     widget.rootEntity == null
//                         ? 'Error Logs'
//                         : widget.rootEntity!.path.split('/').last,
//                     context,
//                     color: Colors.white),
//                 actions: [
//                   ///select all
//                   IconButton(
//                     icon: ctr.selectedItems.isEmpty ||
//                             ctr.selectedItems.length != snapshot.data?.length
//                         ? const Icon(Icons.check_box_outline_blank_rounded)
//                         : const Icon(Icons.check_box_rounded),
//                     onPressed: () async {
//                       if (ctr.selectedItems.isEmpty ||
//                           ctr.selectedItems.length != snapshot.data?.length) {
//                         ctr.setSelectedItems(
//                             (snapshot.data ?? []).map((e) => e.path).toList());
//                       } else {
//                         ctr.clearSelectedItems();
//                       }
//                     },
//                   ),
//                   if (ctr.selectedItems.isNotEmpty)
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () async {
//                         for (String path in ctr.selectedItems) {
//                           final entity = Directory(path).existsSync()
//                               ? Directory(path)
//                               : File(path).existsSync()
//                                   ? File(path)
//                                   : null;
//                           if (entity != null) {
//                             entity.delete(recursive: true).then((value) {
//                               setState(() {});
//                               ctr.removeSelectedItems(entity);
//                             });
//                           }
//                         }
//                       },
//                     ),

//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: () async {
//                       final entity = await _getErrorLogFiles();
//                       final List<XFile> filePaths = [];
//                       for (FileSystemEntity entity in entity) {
//                         if (entity is File) {
//                           filePaths.add(XFile(entity.path));
//                         }
//                       }
//                       Share.shareXFiles(filePaths);
//                     },
//                   ),
//                 ],
//               ),
//               body: snapshot.hasData
//                   ? ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         final entity = snapshot.data![index];
//                         return _EntityItem(
//                           entity: entity,
//                           selected: ctr.selectedItems
//                               .any((element) => element == entity.path),
//                           selecting: ctr.selectedItems.isNotEmpty,
//                           controller: ctr,
//                           onUpdated: (entity) => setState(() {}),
//                         );
//                       },
//                     )
//                   : const Center(child: CircularProgressIndicator()),
//             );
//           });
//         });
//   }

//   Future<List<FileSystemEntity>> _getErrorLogFiles() async {
//     final directory = widget.rootEntity == null
//         ? Directory(
//             '${(await getApplicationDocumentsDirectory()).path}/${LoggerService.folderName}')
//         : Directory(widget.rootEntity!.path);
//     final entity = widget.rootEntity != null
//         ? directory.listSync(recursive: true).toList()
//         : directory.listSync(recursive: true).whereType<Directory>().toList();

//     ///sort by update date
//     entity.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

//     return entity;
//   }
// }

// class _EntityItem extends StatelessWidget {
//   const _EntityItem({
//     super.key,
//     required this.entity,
//     required this.selected,
//     required this.selecting,
//     required this.controller,
//     required this.onUpdated,
//   });
//   final FileSystemEntity entity;
//   final bool selected;
//   final bool selecting;
//   final ErrorLogController controller;
//   final void Function(FileSystemEntity entity) onUpdated;

//   @override
//   Widget build(BuildContext context) {
//     Map<String, int> counts =
//         LoggerService.instance.getFolderFileCount(entity.path);
//     int fileCount = counts['fileCount'] ?? 0;
//     int folderCount = counts['subFolderCount'] ?? 0;
//     Color? iconColor = selected ? null : null;
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: paddingDefault),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//       dense: true,
//       onLongPress: () {
//         if (!selecting) controller.setSelectedItems([entity.path]);
//       },
//       onTap: () {
//         if (selecting) {
//           final selectedItems = controller.selectedItems;
//           if (selectedItems.contains(entity.path)) {
//             controller.removeSelectedItems(entity);
//           } else {
//             controller.addSelectedItems(entity);
//           }
//         } else {
//           navigateTo(context, entity);
//         }
//       },
//       leading: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           decoration: BoxDecoration(
//               color: selected ? getTheme(context).primaryColor : null,
//               shape: BoxShape.circle),
//           padding: EdgeInsets.all(selected ? paddingDefault / 2 : 0),
//           child: _buildIcon(selected ? Colors.white : null)),
//       title: bodyLargeText(getEntityName(entity, iconColor), context,
//           color: iconColor),
//       subtitle: capText(
//           '${getSize(entity)}'
//           '${folderCount > 0 ? (folderCount == 1 ? '  $folderCount folder' : '  $folderCount folders') : ''}'
//           '${fileCount > 0 ? (fileCount == 1 ? '  $fileCount file' : '  $fileCount files') : ''}'
//           '\nModified on: ${entity.statSync().changed.toLocal()}',
//           context,
//           color: iconColor),
//       trailing: selecting
//           ? Checkbox(
//               value: controller.selectedItems.contains(entity.path),
//               onChanged: (value) {
//                 if (value == true) {
//                   controller.addSelectedItems(entity);
//                 } else {
//                   controller.removeSelectedItems(entity);
//                 }
//               },
//             )
//           : PopupMenuButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0)),
//               // color: getTheme(context).primaryColor,
//               elevation: 4.0,
//               surfaceTintColor: getTheme(context).scaffoldBackgroundColor,
//               icon: Icon(Icons.more_vert, color: iconColor),
//               itemBuilder: (context) => [
//                 const PopupMenuItem(value: 'rename', child: Text('Rename')),
//                 const PopupMenuItem(value: 'delete', child: Text('Delete')),
//               ],
//               onSelected: (value) async {
//                 if (value == 'rename') {
//                   entity
//                       .rename(
//                           '${entity.parent.path}/${await getNewName(entity.path.split('/').last)}')
//                       .then((value) => onUpdated(entity));
//                 } else if (value == 'delete') {
//                   entity
//                       .delete(recursive: true)
//                       .then((value) => onUpdated(entity));
//                 }
//               },
//             ),
//     );
//   }

//   String getSize(FileSystemEntity entity) {
//     int size = 0;

//     if (entity is Directory) {
//       for (FileSystemEntity entity
//           in entity.listSync(recursive: true, followLinks: true)) {
//         if (entity is File) {
//           size += entity.statSync().size;
//         } else if (entity is Directory) {
//           size += entity.statSync().size;
//         }
//       }
//     } else if (entity is File) {
//       size = entity.statSync().size;
//     }
//     if (size < 1024) {
//       return '$size bytes';
//     } else if (size < 1024 * 1024) {
//       return '${(size / 1024).toStringAsFixed(2)} KB';
//     } else if (size < 1024 * 1024 * 1024) {
//       return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
//     } else {
//       return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
//     }
//   }

//   Future<String> getNewName(String oldName) async {
//     final textController = TextEditingController(text: oldName);
//     final newName = await showDialog<String>(
//       context: Get.context!,
//       builder: (context) => AlertDialog(
//         title: const Text('Rename'),
//         content: TextField(
//           controller: textController,
//           decoration:
//               const InputDecoration(filled: false, hintText: 'Enter new name'),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => context.pop(), child: const Text('Cancel')),
//           TextButton(
//               onPressed: () => context.pop(textController.text),
//               child: const Text('Rename')),
//         ],
//       ),
//     );
//     return newName ?? oldName;
//   }

//   Widget renameIcon(
//       BuildContext context, Color? iconColor, FileSystemEntity entity) {
//     return IconButton(
//         icon: Icon(Icons.edit, color: iconColor),
//         onPressed: () async => entity
//             .rename(
//                 '${entity.parent.path}/${await getNewName(entity.path.split('/').last)}')
//             .then((value) => onUpdated(entity)));
//   }

//   Widget deleteIcon(BuildContext context, Color? color, Function() onPressed) {
//     return IconButton(
//       icon: Icon(Icons.delete, color: color),
//       onPressed: onPressed,
//     );
//   }

//   Widget _buildIcon(Color? iconColor) {
//     if (entity is Directory) {
//       return Icon(Icons.folder, color: iconColor);
//     } else if (entity is File) {
//       return Icon(Icons.file_copy, color: iconColor);
//     } else if (entity is Link) {
//       return Icon(Icons.link, color: iconColor);
//     } else {
//       return Icon(Icons.error, color: iconColor);
//     }
//   }

//   String getEntityName(FileSystemEntity entity, Color? iconColor) {
//     if (entity is Directory) {
//       return entity.path.split('/').last;
//     } else if (entity is File) {
//       return entity.path.split('/').last;
//     } else if (entity is Link) {
//       return entity.path.split('/').last;
//     } else {
//       return entity.path.split('/').last;
//     }
//   }

//   void navigateTo(BuildContext context, FileSystemEntity entity) {
//     if (entity is Directory) {
//       context.pushNamed(Paths.errorLogListScreen, extra: entity);
//     } else if (entity is File) {
//       context.push(Routes.errorLogScreen, extra: {'path': entity.path});
//     } else if (entity is Link) {
//     } else {}
//   }
// }

// class ErrorLogScreen extends StatelessWidget {
//   final String? path;

//   const ErrorLogScreen({super.key, this.path});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(path?.split('/').last ?? ''),
//       ),
//       body: FutureBuilder<String>(
//         future: _readErrorLog(path),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(snapshot.data!),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }

//   Future<String> _readErrorLog(String? path) async {
//     if (path == null) return 'No errors logged..';
//     final directory = Directory(path);
//     final file = File(
//         // '/data/user/0/com.touchwood.auction_demo/app_flutter/2023-11/25-11-2023.txt');
//         directory.path);

//     // if (file.existsSync()) {
//     //   return file.readAsString();
//     // } else {
//     //   return 'No errors logged for this date.';
//     // }
//     if (file.existsSync()) {
//       // Read the file content
//       String fileContent = file.readAsStringSync();

//       // Split the content into lines
//       List<String> lines = LineSplitter.split(fileContent).toList();

//       // Reverse the order of lines
//       lines = lines.reversed.toList();

//       // Join the reversed lines
//       String reversedContent = lines.join('\n');

//       return reversedContent;
//     } else {
//       return 'No errors logged for this date.';
//     }
//   }

//   String _getFormattedDate(DateTime dateTime) {
//     return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
//   }
// }
