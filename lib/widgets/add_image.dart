import 'dart:io';

import 'package:flutter/material.dart';

class AddImage extends StatelessWidget {
  final File file;
  final VoidCallback onImageTap;

  AddImage(
    this.file,
    this.onImageTap,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: InkWell(
        onTap: onImageTap,
        child: file != null
            ? Image.file(file)
            : Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Tap to add image",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
