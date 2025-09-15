import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/themes/monokai-sublime.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() => runApp(JavaIDE());

class JavaIDE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZEITERMAX IDE',
      theme: ThemeData.dark(),
      home: IDEHome(),
    );
  }
}

class IDEHome extends StatefulWidget {
  @override
  _IDEHomeState createState() => _IDEHomeState();
}

class _IDEHomeState extends State<IDEHome> {
  late CodeController codeController;
  String output = "Output will appear here...";
  List<String> libraries = [];

  @override
  void initState() {
    super.initState();
    codeController = CodeController(
      text: "public class Main {\n  public static void main(String[] args) {\n    System.out.println(\"Hello World\");\n  }\n}",
      language: java,
      theme: monokaiSublimeTheme,
    );
  }

  void runCode() {
    setState(() {
      output = "Simulated Run:\nHello World!";
    });
  }

  void exportProject() async {
    // هنا يحفظ المشروع على الهاتف بصيغة Gradle للرفع على Cloud Build أو PC
    Directory dir = Directory("/storage/emulated/0/ZEITERMAXProjects/Project1");
    if(!dir.existsSync()) dir.createSync(recursive: true);
    File("${dir.path}/Main.java").writeAsStringSync(codeController.text);
    setState(() {
      output = "Project exported to ${dir.path}\nUpload to PC or Cloud Build for APK.";
    });
  }

  void addLibrary() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jar'],
    );
    if (result != null) {
      String path = result.files.single.path!;
      libraries.add(path);
      setState(() {
        output = "Library added: $path";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ZEITERMAX IDE')), 
      body: Column(
        children: [
          Expanded(
            child: CodeField(
              controller: codeController,
              textStyle: TextStyle(fontFamily: 'monospace', fontSize: 14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: runCode, child: Text("Run Code")),
              SizedBox(width: 10),
              ElevatedButton(onPressed: addLibrary, child: Text("Add Library (JAR)")),
              SizedBox(width: 10),
              ElevatedButton(onPressed: exportProject, child: Text("Build APK")),
            ],
          ),
          SizedBox(height: 10),
          Text(output, style: TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
}