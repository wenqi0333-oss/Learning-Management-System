-- =============================================
-- 02_indexes.sql - 数据库索引
-- =============================================

-- =============================================
-- 用户表索引
-- =============================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_users_created_at ON users(created_at);

-- =============================================
-- 用户角色索引
-- =============================================
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role_id);

-- =============================================
-- 课程索引
-- =============================================
CREATE INDEX idx_courses_code ON courses(course_code);
CREATE INDEX idx_courses_active ON courses(is_active);
CREATE INDEX idx_courses_creator ON courses(created_by);
CREATE INDEX idx_courses_dates ON courses(start_date, end_date);

-- =============================================
-- 课程注册索引
-- =============================================
CREATE INDEX idx_enrollments_course ON course_enrollments(course_id);
CREATE INDEX idx_enrollments_user ON course_enrollments(user_id);
CREATE INDEX idx_enrollments_status ON course_enrollments(completion_status);
CREATE INDEX idx_enrollments_date ON course_enrollments(enrollment_date);

-- =============================================
-- 视频索引
-- =============================================
CREATE INDEX idx_videos_course ON videos(course_id);
CREATE INDEX idx_videos_uploader ON videos(uploaded_by);
CREATE INDEX idx_videos_active ON videos(is_active);
CREATE INDEX idx_videos_sequence ON videos(course_id, sequence_order);

-- =============================================
-- 学习材料索引
-- =============================================
CREATE INDEX idx_materials_course ON learning_materials(course_id);
CREATE INDEX idx_materials_type ON learning_materials(material_type);
CREATE INDEX idx_materials_uploader ON learning_materials(uploaded_by);
CREATE INDEX idx_materials_sequence ON learning_materials(course_id, sequence_order);

-- =============================================
-- 视频观看记录索引
-- =============================================
CREATE INDEX idx_video_views_video ON video_views(video_id);
CREATE INDEX idx_video_views_user ON video_views(user_id);
CREATE INDEX idx_video_views_user_video ON video_views(user_id, video_id);
CREATE INDEX idx_video_views_completed ON video_views(completed);

-- =============================================
-- 材料下载记录索引
-- =============================================
CREATE INDEX idx_material_downloads_material ON material_downloads(material_id);
CREATE INDEX idx_material_downloads_user ON material_downloads(user_id);
CREATE INDEX idx_material_downloads_date ON material_downloads(downloaded_at);

-- =============================================
-- 考试索引
-- =============================================
CREATE INDEX idx_exams_course ON exams(course_id);
CREATE INDEX idx_exams_active ON exams(is_active);
CREATE INDEX idx_exams_creator ON exams(created_by);
CREATE INDEX idx_exams_times ON exams(start_time, end_time);

-- =============================================
-- 题目索引
-- =============================================
CREATE INDEX idx_questions_exam ON questions(exam_id);
CREATE INDEX idx_questions_type ON questions(question_type);
CREATE INDEX idx_questions_sequence ON questions(exam_id, sequence_order);

-- =============================================
-- 选择题选项索引
-- =============================================
CREATE INDEX idx_mcq_options_question ON mcq_options(question_id);
CREATE INDEX idx_mcq_options_correct ON mcq_options(is_correct);

-- =============================================
-- 简答题答案索引
-- =============================================
CREATE INDEX idx_short_answer_keys_question ON short_answer_keys(question_id);

-- =============================================
-- 考试尝试索引
-- =============================================
CREATE INDEX idx_attempts_exam ON exam_attempts(exam_id);
CREATE INDEX idx_attempts_user ON exam_attempts(user_id);
CREATE INDEX idx_attempts_status ON exam_attempts(status);
CREATE INDEX idx_attempts_user_exam ON exam_attempts(user_id, exam_id);
CREATE INDEX idx_attempts_start_time ON exam_attempts(start_time);

-- =============================================
-- 学生答案索引
-- =============================================
CREATE INDEX idx_answers_attempt ON student_answers(attempt_id);
CREATE INDEX idx_answers_question ON student_answers(question_id);
CREATE INDEX idx_answers_attempt_question ON student_answers(attempt_id, question_id);

-- 完成索引创建
SELECT 'All indexes created successfully!' AS status;