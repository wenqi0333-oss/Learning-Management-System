-- =============================================
-- 05_seed_data.sql - 初始数据和测试数据
-- =============================================

-- =============================================
-- 1. 插入角色数据
-- =============================================

INSERT INTO roles (role_name, description) VALUES
('Administrator', '系统管理员，拥有所有权限，可以管理用户、课程和系统设置'),
('Trainer', '培训师/教师，可以创建和管理课程、上传资源、创建考试'),
('Student', '学生，可以注册课程、观看视频、下载材料、参加考试');

-- =============================================
-- 2. 插入示例用户（密码需要在应用层加密）
-- =============================================
-- 注意：这里的 password_hash 是示例值，实际应该使用 bcrypt 等算法加密
-- 示例密码都是 "Password123!"

INSERT INTO users (username, email, password_hash, first_name, last_name, phone, is_active) VALUES
-- 管理员账户
('admin', 'admin@lms.edu', '$2a$10$examplehash1', 'Admin', 'User', '+65-1234-5678', TRUE),

-- 教师账户
('teacher1', 'john.smith@lms.edu', '$2a$10$examplehash2', 'John', 'Smith', '+65-2345-6789', TRUE),
('teacher2', 'sarah.johnson@lms.edu', '$2a$10$examplehash3', 'Sarah', 'Johnson', '+65-3456-7890', TRUE),

-- 学生账户
('student1', 'alice.wong@student.edu', '$2a$10$examplehash4', 'Alice', 'Wong', '+65-4567-8901', TRUE),
('student2', 'bob.tan@student.edu', '$2a$10$examplehash5', 'Bob', 'Tan', '+65-5678-9012', TRUE),
('student3', 'charlie.lim@student.edu', '$2a$10$examplehash6', 'Charlie', 'Lim', '+65-6789-0123', TRUE),
('student4', 'diana.lee@student.edu', '$2a$10$examplehash7', 'Diana', 'Lee', '+65-7890-1234', TRUE);

-- =============================================
-- 3. 分配用户角色
-- =============================================

INSERT INTO user_roles (user_id, role_id) VALUES
-- 管理员
(1, 1), -- admin 是 Administrator

-- 教师
(2, 2), -- teacher1 是 Trainer
(3, 2), -- teacher2 是 Trainer

-- 学生
(4, 3), -- student1 是 Student
(5, 3), -- student2 是 Student
(6, 3), -- student3 是 Student
(7, 3); -- student4 是 Student

-- =============================================
-- 4. 插入示例课程
-- =============================================

INSERT INTO courses (course_code, course_name, description, created_by, start_date, end_date, is_active) VALUES
('CS101', 'Introduction to Computer Science', 
 'Learn the fundamentals of computer science including programming basics, algorithms, and data structures.',
 2, '2025-01-15', '2025-05-15', TRUE),

('WEB201', 'Web Development Fundamentals', 
 'Master HTML, CSS, JavaScript and modern web development practices.',
 2, '2025-02-01', '2025-06-01', TRUE),

('DATA301', 'Data Analytics with Python', 
 'Learn data analysis, visualization, and machine learning basics using Python.',
 3, '2025-01-20', '2025-05-20', TRUE);

-- =============================================
-- 5. 学生选课
-- =============================================

INSERT INTO course_enrollments (course_id, user_id, completion_status) VALUES
-- CS101 课程
(1, 4, 'In Progress'),  -- Alice
(1, 5, 'In Progress'),  -- Bob
(1, 6, 'Not Started'),  -- Charlie

-- WEB201 课程
(2, 4, 'In Progress'),  -- Alice
(2, 5, 'Not Started'),  -- Bob
(2, 7, 'In Progress'),  -- Diana

-- DATA301 课程
(3, 6, 'In Progress'),  -- Charlie
(3, 7, 'In Progress');  -- Diana

-- =============================================
-- 6. 插入示例视频
-- =============================================

INSERT INTO videos (course_id, title, description, file_path, file_size, duration, uploaded_by, sequence_order) VALUES
-- CS101 视频
(1, 'Welcome to Computer Science', 'Course introduction and overview', '/videos/cs101/lecture1.mp4', 52428800, 900, 2, 1),
(1, 'Programming Basics - Variables', 'Understanding variables and data types', '/videos/cs101/lecture2.mp4', 67108864, 1200, 2, 2),
(1, 'Control Structures', 'If statements, loops, and conditional logic', '/videos/cs101/lecture3.mp4', 71303168, 1350, 2, 3),

-- WEB201 视频
(2, 'Introduction to HTML', 'HTML structure and basic tags', '/videos/web201/lecture1.mp4', 45678901, 800, 2, 1),
(2, 'CSS Fundamentals', 'Styling web pages with CSS', '/videos/web201/lecture2.mp4', 56789012, 950, 2, 2),

-- DATA301 视频
(3, 'Python Basics for Data Analysis', 'Setting up Python environment', '/videos/data301/lecture1.mp4', 60123456, 1000, 3, 1),
(3, 'Data Visualization with Matplotlib', 'Creating charts and graphs', '/videos/data301/lecture2.mp4', 65234567, 1100, 3, 2);

-- =============================================
-- 7. 插入示例学习材料
-- =============================================

INSERT INTO learning_materials (course_id, title, description, material_type, file_path, file_size, uploaded_by, sequence_order) VALUES
-- CS101 材料
(1, 'Course Syllabus', 'Complete course outline and schedule', 'PDF', '/materials/cs101/syllabus.pdf', 1048576, 2, 1),
(1, 'Python Cheat Sheet', 'Quick reference for Python syntax', 'PDF', '/materials/cs101/python_cheatsheet.pdf', 524288, 2, 2),
(1, 'Programming Exercises', 'Practice problems and solutions', 'Document', '/materials/cs101/exercises.docx', 2097152, 2, 3),

-- WEB201 材料
(2, 'HTML Reference Guide', 'Complete HTML tag reference', 'PDF', '/materials/web201/html_guide.pdf', 3145728, 2, 1),
(2, 'CSS Examples', 'Sample CSS layouts and designs', 'Document', '/materials/web201/css_examples.zip', 5242880, 2, 2),

-- DATA301 材料
(3, 'Dataset Collection', 'Sample datasets for practice', 'Spreadsheet', '/materials/data301/datasets.xlsx', 4194304, 3, 1),
(3, 'Python Libraries Guide', 'Guide to pandas, numpy, matplotlib', 'PDF', '/materials/data301/libraries.pdf', 2621440, 3, 2);

-- =============================================
-- 8. 插入示例考试
-- =============================================

INSERT INTO exams (course_id, exam_title, description, exam_type, duration, passing_marks, created_by, is_active, allow_review, shuffle_questions) VALUES
(1, 'Mid-Term Exam - Programming Fundamentals', 
 'Test your understanding of variables, data types, and control structures', 
 'Mixed', 60, 60.00, 2, TRUE, TRUE, FALSE),

(2, 'HTML & CSS Quiz', 
 'Quick quiz on HTML tags and CSS properties', 
 'MCQ', 30, 70.00, 2, TRUE, TRUE, TRUE),

(3, 'Python Data Analysis Assignment', 
 'Practical exam on data manipulation and visualization', 
 'Short Answer', 90, 50.00, 3, TRUE, TRUE, FALSE);

-- =============================================
-- 9. 插入示例题目
-- =============================================

-- CS101 Mid-Term 题目
INSERT INTO questions (exam_id, question_type, question_text, marks, sequence_order) VALUES
-- MCQ 题目
(1, 'MCQ', 'Which of the following is NOT a valid Python data type?', 10.00, 1),
(1, 'MCQ', 'What is the output of: print(5 // 2)?', 10.00, 2),
(1, 'MCQ', 'Which loop is guaranteed to execute at least once?', 10.00, 3),

-- Short Answer 题目
(1, 'Short Answer', 'Write a Python function that takes a list of numbers and returns the sum of all even numbers.', 30.00, 4),
(1, 'Short Answer', 'Explain the difference between a list and a tuple in Python. Give an example of when to use each.', 20.00, 5);

-- HTML & CSS Quiz 题目
INSERT INTO questions (exam_id, question_type, question_text, marks, sequence_order) VALUES
(2, 'MCQ', 'Which HTML tag is used for creating a hyperlink?', 10.00, 1),
(2, 'MCQ', 'What does CSS stand for?', 10.00, 2),
(2, 'MCQ', 'Which CSS property is used to change text color?', 10.00, 3),
(2, 'MCQ', 'What is the correct HTML for creating a checkbox?', 10.00, 4);

-- Python Data Analysis 题目
INSERT INTO questions (exam_id, question_type, question_text, marks, sequence_order) VALUES
(3, 'Short Answer', 'Given a CSV file with sales data, write Python code to calculate the total revenue by product category.', 40.00, 1),
(3, 'Short Answer', 'Create a bar chart showing the top 5 products by sales using matplotlib. Include proper labels and title.', 30.00, 2),
(3, 'Short Answer', 'Explain how you would handle missing values in a dataset. Provide at least two different approaches.', 20.00, 3);

-- =============================================
-- 10. 插入选择题选项
-- =============================================

-- Question 1 选项 (CS101 Exam)
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(1, 'Integer', FALSE, 1),
(1, 'String', FALSE, 2),
(1, 'Character', TRUE, 3),  -- 正确答案
(1, 'Boolean', FALSE, 4);

-- Question 2 选项
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(2, '2.5', FALSE, 1),
(2, '2', TRUE, 2),  -- 正确答案
(2, '3', FALSE, 3),
(2, 'Error', FALSE, 4);

-- Question 3 选项
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(3, 'for loop', FALSE, 1),
(3, 'while loop', FALSE, 2),
(3, 'do-while loop', TRUE, 3),  -- 正确答案
(3, 'None of the above', FALSE, 4);

-- HTML & CSS Quiz 选项
-- Question 6
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(6, '<link>', FALSE, 1),
(6, '<a>', TRUE, 2),  -- 正确答案
(6, '<href>', FALSE, 3),
(6, '<hyperlink>', FALSE, 4);

-- Question 7
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(7, 'Computer Style Sheets', FALSE, 1),
(7, 'Cascading Style Sheets', TRUE, 2),  -- 正确答案
(7, 'Creative Style System', FALSE, 3),
(7, 'Colorful Style Sheets', FALSE, 4);

-- Question 8
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(8, 'font-color', FALSE, 1),
(8, 'text-color', FALSE, 2),
(8, 'color', TRUE, 3),  -- 正确答案
(8, 'text-style', FALSE, 4);

-- Question 9
INSERT INTO mcq_options (question_id, option_text, is_correct, sequence_order) VALUES
(9, '<input type="check">', FALSE, 1),
(9, '<checkbox>', FALSE, 2),
(9, '<input type="checkbox">', TRUE, 3),  -- 正确答案
(9, '<check>', FALSE, 4);

-- =============================================
-- 11. 插入简答题参考答案
-- =============================================

INSERT INTO short_answer_keys (question_id, model_answer, keywords) VALUES
(4, 'def sum_even_numbers(numbers):
    return sum(num for num in numbers if num % 2 == 0)',
 ARRAY['def', 'function', 'sum', 'even', 'modulo', '%', 'if', 'return']),

(5, 'Lists are mutable (can be modified) while tuples are immutable (cannot be changed after creation). Use lists when you need to modify data, and tuples when data should remain constant or for dictionary keys.',
 ARRAY['mutable', 'immutable', 'modify', 'constant', 'list', 'tuple', 'change']),

(10, 'import pandas as pd
df = pd.read_csv("sales.csv")
revenue_by_category = df.groupby("category")["revenue"].sum()
print(revenue_by_category)',
 ARRAY['pandas', 'read_csv', 'groupby', 'sum', 'category', 'revenue']),

(11, 'import matplotlib.pyplot as plt
# Code to create bar chart
plt.bar(products, sales)
plt.xlabel("Products")
plt.ylabel("Sales")
plt.title("Top 5 Products by Sales")
plt.show()',
 ARRAY['matplotlib', 'plt', 'bar', 'xlabel', 'ylabel', 'title', 'show', 'chart']),

(12, 'Two approaches: 1) Remove rows with missing values using dropna(). 2) Fill missing values with mean/median/mode using fillna(). Choice depends on data percentage missing and analysis requirements.',
 ARRAY['missing', 'dropna', 'fillna', 'mean', 'median', 'remove', 'fill', 'approach']);

-- 完成种子数据插入
SELECT 'Seed data inserted successfully!' AS status;
SELECT 'Total users: ' || COUNT(*) FROM users;
SELECT 'Total courses: ' || COUNT(*) FROM courses;
SELECT 'Total videos: ' || COUNT(*) FROM videos;
SELECT 'Total materials: ' || COUNT(*) FROM learning_materials;
SELECT 'Total exams: ' || COUNT(*) FROM exams;