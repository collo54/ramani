import 'package:flutter/material.dart';

class IconMarkers extends StatelessWidget {
  final List<String> iconList;
  void Function()? onTap;

  IconMarkers({
    super.key,
    required this.iconList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: iconList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: onTap,
              child: ListTile(
                leading: Image.asset(
                  iconList[index],
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  getIconName(iconList[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String getIconName(String path) {
    final regex = RegExp(r'/([^/]+)\.(png|jpg)');
    final match = regex.firstMatch(path);
    if (match != null) {
      return match.group(1) ?? 'null group';
    } else {
      return 'null match';
    }
  }
}
