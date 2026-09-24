# StudyFlow

An Android-first, local-first student planner. The product will help students answer: "What should I study today?"

## Phase 1 scope

Implemented: Flutter Android project, GetX dependency injection and route registry, light/dark/system themes, persisted theme selection, responsive foundation preview, SQLite schema, versioned migration runner, safe startup error state, and automated tests.

Onboarding, bottom navigation, subjects/tasks/exams UI, focus timer, statistics, planner algorithm, notifications, and ads belong to later phases. The preview is intentionally labeled Phase 1 and contains no fabricated progress or demo study records.

## Environment and running

Developed with Flutter 3.47.4 / Dart 3.13.3. Android tooling and licenses must be installed.

```sh
flutter pub get
flutter run -d <android-device-id>
flutter analyze
flutter test
flutter test integration_test/database_test.dart -d <android-device-id>
flutter build apk --debug
```

The integration suite uses a separate database named studyflow_foundation_test.db. It never resets studyflow.db. Theme persistence testing saves and restores the original preference.

Android is the configured target. The repositories/services boundary leaves room for future iOS and web implementations, but sqflite is not a web or Windows database implementation.

## Architecture

- lib/main.dart: initialize critical local services before rendering the app.
- lib/app: GetMaterialApp, bindings, routes, theme and shared design tokens.
- lib/controllers: presentation state, currently theme selection.
- lib/services: SQLite connection and simple device preferences.
- lib/database: immutable schema v1 and sequential migration runner.
- lib/views/home: responsive foundation preview.
- test: widget tests.
- integration_test: Android SQLite and preferences tests.

Future feature controllers will call repositories; repositories will own data mapping and transactions. Planning and statistics logic will remain independent of widgets. Empty repositories and feature controllers are not scaffolded before their features exist.

## Dependencies and cost

All four direct runtime packages are free/open source: get 4.7.3 (MIT), sqflite 2.4.4 (BSD-2-Clause), path 1.9.1 (BSD-3-Clause), shared_preferences 2.5.5 (BSD-3-Clause). Preserve their license notices. flutter_test and integration_test ship with Flutter; flutter_lints supplies development lint rules. The lockfile is committed for reproducible dependency resolution.

Phase 1 uses no backend, account, API key, cloud database, analytics, ads, or recurring service. Core startup and themes work offline. Package downloads and build-tool installation require internet during development.

## Database

SQLite file: studyflow.db in the app's private database directory.

| Table | Purpose and relationships |
| --- | --- |
| subjects | Name, icon, color, semester, optional teacher, archive status |
| topics | Subject child; difficulty 1–3, estimated minutes, completion |
| tasks | Optional subject, due date/time, priority 0–3, completion |
| exams | Subject child, exam date/time, notes |
| study_sessions | UTC start/end, exact duration in seconds, nullable subject/topic/task links |
| study_plans | Exam child, generation timestamp, algorithm version |
| study_plan_items | Plan child, optional topic/task, day, planned minutes, revision/completion flags |
| user_settings | Singleton durable profile, study preferences, onboarding and notification categories |
| active_focus | Singleton timestamp-based timer state for the later focus feature |

All entity IDs are SQLite integer primary keys. Foreign keys are enabled on every open. Subject deletion cascades to its topics, tasks and exams, and exam deletion cascades to plans/items. Completed study history is retained with deleted links set to NULL. Archive will be the preferred subject action; later destructive UI actions must explain the cascade and require confirmation.

UTC instants are integer milliseconds. Calendar dates are local YYYY-MM-DD, optional wall-clock times HH:mm. Duration seconds avoid truncating study history; display minutes are derived. Future repositories must validate real dates and matching subject/topic/task relationships. SQL checks already reject blank titles, invalid enums, nonpositive planned durations, and invalid booleans.

Settings start with defaults and onboarding incomplete; no subjects or study history are seeded. Theme is the only preference currently stored through shared_preferences. Statistics, streaks and achievement eligibility will be derived from history rather than duplicated counters.

### Migrations

Version 1 is the first released schema. Do not rewrite it after release. Append migration N in Migrations.steps and increment Schema.version. New installs execute the same ordered chain as upgrades. sqflite owns the callback transaction; errors roll back. Missing migration steps and downgrades fail safely without deleting user data.

Tests cover creation, CRUD, reopen persistence, foreign-key enforcement, history preservation, a successful simulated v1-to-v2 upgrade, and rollback of a failed simulated upgrade. Production remains at v1.

## Design

Warm white and charcoal with soft lime highlights; rounded cards, readable typography and roomy layouts inspired by the supplied reference. The shared theme supports light, dark and system modes. Feature animations and data visualizations will be built alongside their real state in later phases.

## Manual Phase 1 check

1. Run on Android and confirm the StudyFlow foundation preview appears.
2. Switch Light, Dark and System.
3. Close and reopen the app; the selected theme should remain.
4. In System mode, change the device appearance and confirm the app follows it.
5. Try a narrow screen and larger system text; content should scroll without clipping.
6. Reopen in airplane mode; the preview and theme switching should still work.
7. Run the Android integration suite for database checks (CRUD screens arrive in Phase 3).

## Privacy and release status

Study data remains in private on-device storage. No app-level cloud sync or telemetry is implemented. Android's OS backup may apply under device settings; a release backup policy must be decided before publication. No notification, location, camera or microphone permission is requested. The Flutter debug manifest includes internet access for debugging; core release functionality does not need it.

This is a development foundation, not a store-ready build. The generated com.example.studyflow application ID, launcher icon and debug signing must be replaced/configured before publication. No production signing keys or advertising IDs are present.
