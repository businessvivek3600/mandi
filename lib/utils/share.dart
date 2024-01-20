import '/constants/constants_index.dart';

String getAppPageUrl(String path) =>
    Uri.encodeFull('${AppConst.siteUrl}$path').toString();
