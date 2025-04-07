
import 'package:flutter/material.dart';

class StatusDropDownManageLeads extends StatefulWidget {
  final String status;
  final Function(String) onStatusChanged;
  final Color statusColor;
  final Color statusTextColor;

  const StatusDropDownManageLeads({
    super.key,
    required this.status,
    required this.onStatusChanged,
    required this.statusColor,
    required this.statusTextColor,
  });

  @override
  State<StatusDropDownManageLeads> createState() =>
      _StatusDropDownManageLeadsState();
}

class _StatusDropDownManageLeadsState extends State<StatusDropDownManageLeads> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.statusColor, // ✅ Uses the passed color
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: () {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust as needed
            items: [
              PopupMenuItem(value: "Pending", child: Text("Pending")),
              PopupMenuItem(
                  value: "Proposal Accepted", child: Text("Proposal Accepted")),
              PopupMenuItem(
                  value: "Qualified Lead", child: Text("Qualified Lead")),
            ],
          ).then((String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedStatus = newValue;
              });
              widget.onStatusChanged(newValue);
            }
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedStatus,
              style: TextStyle(
                color: widget.statusTextColor,
              ),
            ),
            Icon(Icons.arrow_drop_down,
                color: widget.statusTextColor, size: 18),
          ],
        ),
      ),
    );
  }
}
