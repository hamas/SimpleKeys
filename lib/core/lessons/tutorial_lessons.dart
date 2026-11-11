import 'package:flutter/foundation.dart';

/// Single interactive lesson step.
@immutable
class LessonStep {
  final String noteName; // e.g. 'C', 'G', 'A'
  final int? preferredOctave; // e.g. 3 or 4 (or null if any octave matches)
  final String lyric;

  const LessonStep({
    required this.noteName,
    this.preferredOctave,
    this.lyric = '',
  });
}

/// Interactive tutorial song / scale for Teach Mode.
@immutable
class TutorialSong {
  final String id;
  final String title;
  final String subtitle;
  final List<LessonStep> steps;

  const TutorialSong({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.steps,
  });

  static const List<TutorialSong> sampleSongs = [
    TutorialSong(
      id: 'c_major_scale',
      title: 'C Major Scale',
      subtitle: 'Ascending & Descending',
      steps: [
        LessonStep(noteName: 'C', lyric: 'Do'),
        LessonStep(noteName: 'D', lyric: 'Re'),
        LessonStep(noteName: 'E', lyric: 'Mi'),
        LessonStep(noteName: 'F', lyric: 'Fa'),
        LessonStep(noteName: 'G', lyric: 'Sol'),
        LessonStep(noteName: 'A', lyric: 'La'),
        LessonStep(noteName: 'B', lyric: 'Si'),
        LessonStep(noteName: 'C', lyric: 'Do'),
      ],
    ),
    TutorialSong(
      id: 'twinkle_twinkle',
      title: 'Twinkle Twinkle',
      subtitle: 'Nursery Classic',
      steps: [
        LessonStep(noteName: 'C', lyric: 'Twin-'),
        LessonStep(noteName: 'C', lyric: 'kle'),
        LessonStep(noteName: 'G', lyric: 'twin-'),
        LessonStep(noteName: 'G', lyric: 'kle'),
        LessonStep(noteName: 'A', lyric: 'lit-'),
        LessonStep(noteName: 'A', lyric: 'tle'),
        LessonStep(noteName: 'G', lyric: 'star,'),
        LessonStep(noteName: 'F', lyric: 'how'),
        LessonStep(noteName: 'F', lyric: 'I'),
        LessonStep(noteName: 'E', lyric: 'won-'),
        LessonStep(noteName: 'E', lyric: 'der'),
        LessonStep(noteName: 'D', lyric: 'what'),
        LessonStep(noteName: 'D', lyric: 'you'),
        LessonStep(noteName: 'C', lyric: 'are!'),
      ],
    ),
    TutorialSong(
      id: 'ode_to_joy',
      title: 'Ode to Joy',
      subtitle: 'Beethoven 9th',
      steps: [
        LessonStep(noteName: 'E', lyric: 'Joy,'),
        LessonStep(noteName: 'E', lyric: 'bright'),
        LessonStep(noteName: 'F', lyric: 'spark'),
        LessonStep(noteName: 'G', lyric: 'of'),
        LessonStep(noteName: 'G', lyric: 'di-'),
        LessonStep(noteName: 'F', lyric: 'vi-'),
        LessonStep(noteName: 'E', lyric: 'ni-'),
        LessonStep(noteName: 'D', lyric: 'ty,'),
        LessonStep(noteName: 'C', lyric: 'daugh-'),
        LessonStep(noteName: 'C', lyric: 'ter'),
        LessonStep(noteName: 'D', lyric: 'of'),
        LessonStep(noteName: 'E', lyric: 'E-'),
        LessonStep(noteName: 'E', lyric: 'ly-'),
        LessonStep(noteName: 'D', lyric: 'si-'),
        LessonStep(noteName: 'D', lyric: 'um!'),
      ],
    ),
  ];
}

