import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zkmf2024_app/dto/app_page.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<AppPageDTO>> _news;

  @override
  void initState() {
    super.initState();
    _news = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktuelles"),
        actions: homeAction(context),
      ),
      body: Center(
        child: FutureBuilder<List<AppPageDTO>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.requireData.length,
                itemBuilder: (BuildContext context, int index) {
                  var requireData = snapshot.requireData[index];
                  return ListTile(
                    trailing: const Icon(
                      Icons.navigate_next_sharp,
                      color: Colors.white,
                    ),
                    onTap: () {
                      context.push('/page/${requireData.id}');
                    },
                    title: Text(
                      requireData.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(DateFormat("dd.MM.yyyy").format(requireData.createdAt)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            } else if (snapshot.hasError) {
              return const GeneralErrorWidget();
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
