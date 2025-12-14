CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    group_number VARCHAR(10) NOT NULL
);
CREATE TABLE subjects (
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL
);
CREATE TABLE grades (
    grade_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    grade INT CHECK (grade BETWEEN 1 AND 5),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
	FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    date_attended DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('attend', 'absent', 'late')),
	FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE notes (
    note_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    note_text TEXT NOT NULL,
	FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (full_name, group_number) VALUES
('Иванова Мария Александровна', 'ИУ7-13Б'),
('Романова Анна Юрьевна', 'ИУ7-13Б'),
('Овечкин Николай Петрович', 'ИУ7-13Б'),
('Коновалова Виктория Михайловна', 'ИУ7-13Б'),
('Кузнецова Елена Дмитриевна', 'ИУ7-13Б'),
('Попов Юрий Алексеевич', 'ИУ7-13Б'),
('Волков Алексей Федорович', 'ИУ7-13Б');

INSERT INTO subjects (subject_name) VALUES
('Математический анализ'),
('Аналитическая геометрия'),
('Информатика');

INSERT INTO grades (student_id, subject_id, grade)VALUES
(1,1,3),
(1,2,4),
(1,3,5),
(2,1,4),
(2,2,4),
(2,3,4),
(3,1,5),
(3,2,4),
(3,3,4),
(4,1,5),
(4,2,5),
(4,3,4),
(5,1,4),
(5,2,4),
(5,3,3),
(6,1,5),
(6,2,5),
(6,3,5);

INSERT INTO attendance (student_id, date_attended, status)VALUES
(1,'10.12.2025','attend'),
(2,'10.12.2025','absent'),
(3,'10.12.2025','late'),
(4,'10.12.2025','late'),
(5,'10.12.2025','attend'),
(6,'10.12.2025','attend'),
(1,'11.12.2025','attend'),
(2,'11.12.2025','attend'),
(3,'11.12.2025','attend'),
(4,'11.12.2025','absent'),
(5,'11.12.2025','late'),
(6,'11.12.2025','attend');

INSERT INTO notes (student_id, note_text) VALUES
(1, 'Любит информатику'),
(2, 'Хорошо работает в команде'),
(3, 'Прогресс по информатике'),
(4, 'Редко посещает занятия по информатике'),
(5, 'Нужна помощь по информатике'),
(6, 'Отличник по всем предметам');

CREATE INDEX idx_students_group ON students(group_number);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_notes_text ON notes USING GIN (to_tsvector('russian', note_text));

CREATE VIEW student_avg_grades AS
SELECT 
    s.student_id,
    s.full_name,
    AVG(g.grade) AS average_grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.full_name;

BEGIN;
    INSERT INTO students (full_name, group_number) 
    VALUES ('Смирнов Артем Игоревич', 'ИУ7-13Б') ;

    INSERT INTO grades (student_id, subject_id, grade)
    VALUES (7,1,5),
           (7,2,4),
           (7,3,4);
COMMIT;

SELECT student_id, full_name, group_number
FROM students
WHERE group_number = 'ИУ7-13Б'
  AND (
    student_id IN (
      SELECT student_id
      FROM students
      WHERE group_number = 'ИУ7-13Б' AND student_id < 3
      ORDER BY student_id DESC
      LIMIT 2
    )
    OR
    student_id IN (
      SELECT student_id
      FROM students
      WHERE group_number = 'ИУ7-13Б' AND student_id > 3
      ORDER BY student_id ASC
      LIMIT 3
    )
  )
  AND student_id != 3 
ORDER BY student_id;

SELECT * FROM student_avg_grades WHERE student_id = 1;

SELECT AVG(g.grade) 
FROM grades g
JOIN subjects s ON g.subject_id = s.subject_id
WHERE s.subject_name = 'Информатика';

SELECT * FROM notes 
WHERE to_tsvector('russian', note_text) @@ to_tsquery('russian', 'Информатика');

BEGIN;
    UPDATE attendance 
    SET status = 'attend' 
    WHERE student_id = 1 AND date_attended = '10.12.2025';
COMMIT;

SELECT s.student_id, s.full_name, sub.subject_name, g.grade 
FROM grades g
JOIN subjects sub ON g.subject_id = sub.subject_id
JOIN students s ON g.student_id = s.student_id
ORDER BY s.student_id;