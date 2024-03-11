import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/app_page.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
import 'package:zkmf2024_app/widgets/cloudflare_image.dart';
import 'package:zkmf2024_app/widgets/general_error.dart';

class DynamicPageScreen extends StatefulWidget {
  final int id;

  const DynamicPageScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _DynamicPageScreenState();
}

class _DynamicPageScreenState extends State<DynamicPageScreen> {
  late Future<AppPageDTO> _appPage;

  @override
  void initState() {
    super.initState();
    _appPage = fetchAppPage(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _appPage,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.requireData.title);
            } else {
              return const Text("");
            }
          },
        ),
      ),
      body: FutureBuilder<AppPageDTO>(
        future: _appPage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var requireData = snapshot.requireData;

            return SingleChildScrollView(
              child: Column(
                children: buildContent(requireData),
              ),
            );
          } else if (snapshot.hasError) {
            return const GeneralErrorWidget();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<Widget> buildContent(AppPageDTO page) {
    return [
      CloudflareImage(
        cloudflareId: page.cloudflareId,
        paddingOuter: EdgeInsets.zero,
        paddingInner: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal:  8.0),
        child: MarkdownBody(
          data: page.markdown,
          styleSheet: MarkdownStyleSheet(
              a: const TextStyle(
            color: gruen,
            decoration: TextDecoration.underline,
          )),
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrl(Uri.parse(href));
            }
          },
        ),
      )
    ];
  }
}
