import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/verein_member_info.dart';
import 'package:zkmf2024_app/service/backend_service.dart';

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<StatefulWidget> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedVerein = box.read(selectedVereinKey);
    return FutureBuilder(
      future: selectedVerein != null ? fetchMemberInfo(box.read(selectedVereinKey)!) : Future.value(null),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (hasFutureEntries(snapshot.requireData)) {
            return Padding(
                padding: const EdgeInsets.all(4),
                child: TextButton(
                  onPressed: () {
                    context.push('/member');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(violett),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Text(
                      "deine Detailinformationen",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ));
          }
        }
        return Container();
      },
    );
  }

  bool hasFutureEntries(VereinMemberInfoDTO? info) {
    if (info != null) {
      return info.timetableEntries.any((e) => !e.inPast);
    } else {
      return false;
    }
  }
}
