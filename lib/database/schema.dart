/// Version 1: local study data. Instants use UTC milliseconds; calendar dates
/// use YYYY-MM-DD and optional wall-clock times use HH:mm.
abstract final class Schema {
  static const version = 1;
  static const statements = [
    """CREATE TABLE subjects (
      id INTEGER PRIMARY KEY, name TEXT NOT NULL CHECK(length(trim(name)) > 0),
      icon TEXT NOT NULL DEFAULT 'book', color INTEGER NOT NULL,
      semester TEXT NOT NULL DEFAULT '', teacher TEXT,
      created_at INTEGER NOT NULL, archived INTEGER NOT NULL DEFAULT 0 CHECK(archived IN (0,1))
    )""",
    """CREATE TABLE topics (
      id INTEGER PRIMARY KEY, subject_id INTEGER NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
      name TEXT NOT NULL CHECK(length(trim(name)) > 0),
      difficulty INTEGER NOT NULL DEFAULT 2 CHECK(difficulty BETWEEN 1 AND 3),
      estimated_minutes INTEGER NOT NULL CHECK(estimated_minutes > 0),
      completed INTEGER NOT NULL DEFAULT 0 CHECK(completed IN (0,1)),
      completed_at INTEGER, created_at INTEGER NOT NULL
    )""",
    """CREATE TABLE tasks (
      id INTEGER PRIMARY KEY, subject_id INTEGER REFERENCES subjects(id) ON DELETE CASCADE,
      title TEXT NOT NULL CHECK(length(trim(title)) > 0), description TEXT NOT NULL DEFAULT '',
      due_date TEXT NOT NULL, due_time TEXT,
      priority INTEGER NOT NULL DEFAULT 1 CHECK(priority BETWEEN 0 AND 3),
      estimated_minutes INTEGER NOT NULL DEFAULT 25 CHECK(estimated_minutes > 0),
      completed INTEGER NOT NULL DEFAULT 0 CHECK(completed IN (0,1)),
      created_at INTEGER NOT NULL, completed_at INTEGER
    )""",
    """CREATE TABLE exams (
      id INTEGER PRIMARY KEY, subject_id INTEGER NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
      title TEXT NOT NULL CHECK(length(trim(title)) > 0), exam_date TEXT NOT NULL,
      exam_time TEXT, notes TEXT NOT NULL DEFAULT '', created_at INTEGER NOT NULL
    )""",
    """CREATE TABLE study_sessions (
      id INTEGER PRIMARY KEY, subject_id INTEGER REFERENCES subjects(id) ON DELETE SET NULL,
      topic_id INTEGER REFERENCES topics(id) ON DELETE SET NULL,
      task_id INTEGER REFERENCES tasks(id) ON DELETE SET NULL,
      start_time INTEGER NOT NULL, end_time INTEGER NOT NULL CHECK(end_time >= start_time),
      duration_seconds INTEGER NOT NULL CHECK(duration_seconds >= 0),
      completed INTEGER NOT NULL CHECK(completed IN (0,1))
    )""",
    """CREATE TABLE study_plans (
      id INTEGER PRIMARY KEY, exam_id INTEGER NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
      generated_at INTEGER NOT NULL, algorithm_version INTEGER NOT NULL DEFAULT 1
    )""",
    """CREATE TABLE study_plan_items (
      id INTEGER PRIMARY KEY, plan_id INTEGER NOT NULL REFERENCES study_plans(id) ON DELETE CASCADE,
      topic_id INTEGER REFERENCES topics(id) ON DELETE SET NULL,
      task_id INTEGER REFERENCES tasks(id) ON DELETE SET NULL,
      title TEXT NOT NULL, scheduled_date TEXT NOT NULL,
      planned_minutes INTEGER NOT NULL CHECK(planned_minutes > 0),
      is_revision INTEGER NOT NULL DEFAULT 0 CHECK(is_revision IN (0,1)),
      completed INTEGER NOT NULL DEFAULT 0 CHECK(completed IN (0,1))
    )""",
    """CREATE TABLE user_settings (
      id INTEGER PRIMARY KEY CHECK(id = 1), name TEXT NOT NULL DEFAULT '',
      education_level TEXT NOT NULL DEFAULT 'Other'
        CHECK(education_level IN ('School','College','University','Other')),
      daily_goal_minutes INTEGER NOT NULL DEFAULT 120 CHECK(daily_goal_minutes > 0),
      focus_minutes INTEGER NOT NULL DEFAULT 25 CHECK(focus_minutes > 0),
      break_minutes INTEGER NOT NULL DEFAULT 5 CHECK(break_minutes > 0),
      streak_minimum_minutes INTEGER NOT NULL DEFAULT 15 CHECK(streak_minimum_minutes > 0),
      first_day_of_week INTEGER NOT NULL DEFAULT 1 CHECK(first_day_of_week BETWEEN 1 AND 7),
      onboarding_completed INTEGER NOT NULL DEFAULT 0 CHECK(onboarding_completed IN (0,1)),
      study_reminders INTEGER NOT NULL DEFAULT 0 CHECK(study_reminders IN (0,1)),
      exam_reminders INTEGER NOT NULL DEFAULT 0 CHECK(exam_reminders IN (0,1)),
      task_reminders INTEGER NOT NULL DEFAULT 0 CHECK(task_reminders IN (0,1)),
      streak_reminders INTEGER NOT NULL DEFAULT 0 CHECK(streak_reminders IN (0,1))
    )""",
    """CREATE TABLE active_focus (
      id INTEGER PRIMARY KEY CHECK(id = 1),
      subject_id INTEGER REFERENCES subjects(id) ON DELETE SET NULL,
      topic_id INTEGER REFERENCES topics(id) ON DELETE SET NULL,
      task_id INTEGER REFERENCES tasks(id) ON DELETE SET NULL,
      phase TEXT NOT NULL CHECK(phase IN ('focus','break')),
      status TEXT NOT NULL CHECK(status IN ('running','paused')),
      started_at INTEGER NOT NULL, deadline_at INTEGER,
      remaining_seconds INTEGER NOT NULL CHECK(remaining_seconds >= 0),
      elapsed_seconds INTEGER NOT NULL DEFAULT 0 CHECK(elapsed_seconds >= 0),
      target_seconds INTEGER NOT NULL CHECK(target_seconds > 0),
      CHECK(status != 'running' OR deadline_at IS NOT NULL)
    )""",
    'CREATE INDEX topics_subject ON topics(subject_id)',
    'CREATE INDEX tasks_subject ON tasks(subject_id)',
    'CREATE INDEX tasks_due ON tasks(completed, due_date)',
    'CREATE INDEX exams_subject ON exams(subject_id)',
    'CREATE INDEX exams_date ON exams(exam_date)',
    'CREATE INDEX sessions_subject ON study_sessions(subject_id)',
    'CREATE INDEX sessions_start ON study_sessions(start_time)',
    'CREATE INDEX plans_exam ON study_plans(exam_id)',
    'CREATE INDEX plan_items_plan ON study_plan_items(plan_id)',
    'CREATE INDEX plan_items_date ON study_plan_items(scheduled_date)',
    'INSERT INTO user_settings(id) VALUES(1)',
  ];
}
