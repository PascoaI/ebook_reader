
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../bloc/book_list_bloc.dart';

class BookViewerScreen extends StatefulWidget {
  final String download_url;
  final String title;
  const BookViewerScreen(this.download_url, this.title, {Key? key}) : super(key: key);
  @override
  _BookViewerScreenState createState() => _BookViewerScreenState();
}


class _BookViewerScreenState extends State<BookViewerScreen> {
  final _bloc = GetIt.instance<BookListBloc>();
  final platform = MethodChannel('my_channel');
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  @override
  void initState() {
    download();
    _bloc.onLoadBooks();
    super.initState();
  }

  Future<void> fetchAndroidVersion() async {
    final String? version = await getAndroidVersion();
    if (version != null) {
      String? firstPart;
      if (version.toString().contains(".")) {
        int indexOfFirstDot = version.indexOf(".");
        firstPart = version.substring(0, indexOfFirstDot);
      } else {
        firstPart = version;
      }
      int intValue = int.parse(firstPart);
      if (intValue >= 13) {
        await startDownload();
      } else {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          await startDownload();
        } else {
          await Permission.storage.request();
        }
      }
      print("ANDROID VERSION: $intValue");
    }
  }

  Future<String?> getAndroidVersion() async {
    try {
      final String version = await platform.invokeMethod('getAndroidVersion');
      return version;
    } on PlatformException catch (e) {
      print("FAILED TO GET ANDROID VERSION: ${e.message}");
      return null;
    }
  }

  download() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (kDebugMode) {
        print('download');
      }
      await downloadFile();
    } else {
      loading = false;
    }
  }

  Future downloadFile() async {
    if (await Permission.storage.isGranted) {
      await Permission.storage.request();
      await startDownload();
    } else {
      await startDownload();
    }
  }

  startDownload() async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/archive.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        widget.download_url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (receivedBytes == totalBytes) {
            loading = false;
            setState(() {
              filePath = path;
            });
          }
        },
      );
    } else {
      loading = false;
      setState(() {
        filePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Leitor de Livros'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: loading
              ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Download em andamento'),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  print("=====filePath======$filePath");
                  if (filePath == "") {
                    download();
                  } else {
                    VocsyEpub.setConfig(
                      themeColor: Theme.of(context).primaryColor,
                      identifier: "iosBook",
                      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                      allowSharing: true,
                      enableTts: true,
                      nightMode: true,
                    );

                    // get current locator
                    VocsyEpub.locatorStream.listen((locator) {
                      print('LOCATOR: $locator');
                    });

                    VocsyEpub.open(
                      filePath,
                      lastLocation: EpubLocator.fromJson({
                        "bookId": "2239",
                        "href": "/OEBPS/ch06.xhtml",
                        "created": 1539934158390,
                        "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
                      }),
                    );
                  }
                },
                child: Text('Abrir o livro ${widget.title}', textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }

}