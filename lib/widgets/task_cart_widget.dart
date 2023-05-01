import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    String formattedDate = DateFormat('yyyy-MM-dd').format(task.timeModified);
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String date;
    if (formattedDate == todayDate) {
      date = DateFormat('HH:mm').format(task.timeModified).toString();
    } else {
      date = DateFormat('dd/MM/yyyy').format(task.timeModified).toString();
    }
    DateFormat('dd/MM/yyyy').format(task.timeModified).toString();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15).add(
        const EdgeInsets.symmetric(horizontal: 12),
      ),
      height: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Row(
        children: [
          Container(
            width: 8,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: colorPrimary.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      task.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
