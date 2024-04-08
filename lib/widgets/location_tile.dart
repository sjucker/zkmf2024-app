import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/dto/location.dart';

class LocationTileWidget extends StatelessWidget {
  final LocationDTO location;

  const LocationTileWidget(this.location, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      trailing: const Icon(
        Icons.navigate_next_sharp,
        color: Colors.white,
      ),
      onTap: () {
        context.push('/wettspiellokale/${location.identifier}');
      },
      title: Text(location.name),
    );
  }
}
