import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../video_clip/clipper_view.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    File _image;
    final picker = ImagePicker();

    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(_image.absolute);
        } else {
          print('No image selected.');
        }
      });
    }

    Future getVideo() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(_image.absolute);
        } else {
          print('No video selected.');
        }
      });
    }

    Future getVideo2() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(_image.absolute);
        } else {
          print('No video selected.');
        }
      });
    }


    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getImage,
              child: Text("image"),
            ),
            ElevatedButton(
              onPressed: getVideo,
              child: Text("video"),
            ),
            ElevatedButton(
              onPressed: getVideo2,
              child: Text("video2"),
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                  allowCompression: false,
                );
                if (result != null) {
                  File file = File(result.files.single.path!);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ClipperView(file);
                    }),
                  );
                }
              },
              child: Text("video3"),
            ),
          ],
        ),
      ),
    );
  }
}
