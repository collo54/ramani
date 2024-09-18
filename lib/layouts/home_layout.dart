import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/read_private_markers_provider.dart';
import '../widgets/home_data_widget.dart';
import '../widgets/instructions_widget.dart';

class HomeLayout extends ConsumerWidget {
  const HomeLayout({super.key, this.page});
  final int? page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('display home data ****');
    ref.watch(readPrivateMarkersProvider);
    final value = ref.watch(readPrivateMarkersProvider);
    return value.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      data: (displayDataModelList) {
        if (displayDataModelList.isNotEmpty) {
          return ListView.builder(
            itemCount: displayDataModelList.length,
            itemBuilder: (context, index) {
              return HomeDataWidget(
                title: displayDataModelList[index].markerMetaData.infoWindow,
                description:
                    displayDataModelList[index].markerMetaData.description,
                url: displayDataModelList[index].markerMetaData.assetString,
                time: parseTimeHour(displayDataModelList[index].timeStamp!),
                date:
                    parseTimestampDate(displayDataModelList[index].timeStamp!),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ViewWholeResponsePage(
                  //       dataModel: displayDataModelList[index],
                  //     ),
                  //   ),
                  // );
                },
              );
            },
          );
        } else {
          return const Column(
            children: [
              InstructionsWidget(
                title: 'Instructions',
                description:
                    'Navigate to the first tab to create custom map markers.\nSaved Markers from different channels will appear here.',
              ),
            ],
          );
        }
      },
    );
  }

  String parseTimeHour(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String parseTimestampDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.day} ${getShortMonth(dateTime.month)} ${dateTime.year}';
  }

  String getShortMonth(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
