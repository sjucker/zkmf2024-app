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

  late Future<VereinMemberInfoDTO?> _info;
  late String? _selectedVerein;

  @override
  void initState() {
    super.initState();
    _selectedVerein = box.read(selectedVereinKey);
    _info = _selectedVerein != null ? fetchMemberInfo(_selectedVerein!) : Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _info,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (hasFutureEntries(snapshot.requireData)) {
            return Padding(
                padding: const EdgeInsets.all(10),
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
