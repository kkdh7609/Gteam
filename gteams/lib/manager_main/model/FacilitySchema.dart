import 'package:flutter/material.dart';

class Facility {
  final String name;
  final LinearGradient background;
  final String subtitle;
  final String image;
  final bool lastindex;

  Facility(
      {this.name,
        this.background,
        this.subtitle,
        this.image,
        this.lastindex,
      });
}
