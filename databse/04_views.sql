-- =============================================
-- 04_views.sql - 数据库视图
-- =============================================

-- =============================================
-- 1. 课程统计视图
-- =============================================

CREATE VIEW course_statistics AS
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.description,
    c.start_date,
    c.end_date,
    u.username AS creator_username,
    u.first_name || ' ' || u.last_name AS creator_name,
    COUNT(DISTINCT ce.user_id) AS enrolled_students,
    COUNT(DISTINCT v.video_id) AS total_videos,
    COUNT(DISTINCT lm.material_id) AS total_materials,
    COUNT(DISTINCT e.exam_id) AS total_exams,
    c.created_at,
    c.is_active
FROM courses c
LEFT JOIN users u ON c.created_by = u.user_id
LEFT JOIN course_enrollments ce ON c.course_id = ce.course_id
LEFT JOIN videos v ON c.course_id = v.course_id AND v.is_active = TRUE
LEFT JOIN learning_materials lm ON c.course_id = lm.course_id AND lm.is_active = TRUE
LEFT JOIN exams e ON c.course_id = e.exam_id AND e.is_active = TRUE
WHERE c.is_active = TRUE
GROUP BY c.course_id, c.course_code, c.course_name, c.description, 
         c.start_date, c.end_date, u.username, u.first_name, u.last_name, 
         c.created_at, c.is_active;

COMMENT ON VIEW course_statistics IS '课程统计信息视图，包含学生数、资源数等';

-- =============================================
-- 2. 学生成绩报告视图
-- =============================================

CREATE VIEW student_exam_results AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.email,
    c.course_id,
    c.course_name,
    e.exam_id,
    e.exam_title,
    e.total_marks AS exam_total_marks,
    e.passing_marks AS exam_passing_marks,
    ea.attempt_id,
    ea.score,
    ea.total_marks AS attempt_total_marks,
    ROUND((ea.score / NULLIF(ea.total_marks, 0) * 100), 2) AS percentage,
    ea.is_passed,
    ea.start_time,
    ea.end_time,
    EXTRACT(EPOCH FROM (ea.end_time - ea.start_time))/60 AS duration_minutes,
    ea.status,
    ea.graded_at
FROM users u
JOIN exam_attempts ea ON u.user_id = ea.user_id
JOIN exams e ON ea.exam_id = e.exam_id
JOIN courses c ON e.course_id = c.course_id
WHERE ea.status = 'Completed';

COMMENT ON VIEW student_exam_results IS '学生考试成绩详细报告视图';

-- =============================================
-- 3. 学生学习进度视图
-- =============================================

CREATE VIEW student_learning_progress AS
SELECT 
    u.user_id,
    u.username,
    u.first_name || ' ' || u.last_name AS student_name,
    c.course_id,
    c.course_name,
    ce.enrollment_date,
    ce.completion_status,
    ce.completion_date,
    COUNT(DISTINCT vv.video_id) AS videos_watched,
    COUNT(DISTINCT v.video_id) AS total_videos,
    ROUND(
        (COUNT(DISTINCT vv.video_id)::DECIMAL / NULLIF(COUNT(DISTINCT v.video_id), 0)) * 100, 
        2
    ) AS video_completion_percentage,
    COUNT(DISTINCT md.material_id) AS materials_downloaded,
    COUNT(DISTINCT lm.material_id) AS total_materials,
    COUNT(DISTINCT ea.exam_id) AS exams_taken,
    COUNT(DISTINCT e.exam_id) AS total_exams,
    COUNT(DISTINCT CASE WHEN ea.is_passed = TRUE THEN ea.exam_id END) AS exams_passed
FROM users u
JOIN course_enrollments ce ON u.user_id = ce.user_id
JOIN courses c ON ce.course_id = c.course_id
LEFT JOIN videos v ON c.course_id = v.course_id AND v.is_active = TRUE
LEFT JOIN video_views vv ON u.user_id = vv.user_id AND vv.video_id = v.video_id AND vv.completed = TRUE
LEFT JOIN learning_materials lm ON c.course_id = lm.course_id AND lm.is_active = TRUE
LEFT JOIN material_downloads md ON u.user_id = md.user_id AND md.material_id = lm.material_id
LEFT JOIN exams e ON c.course_id = e.course_id AND e.is_active = TRUE
LEFT JOIN exam_attempts ea ON u.user_id = ea.user_id AND ea.exam_id = e.exam_id AND ea.status = 'Completed'
GROUP BY u.user_id, u.username, u.first_name, u.last_name, c.course_id, 
         c.course_name, ce.enrollment_date, ce.completion_status, ce.completion_date;

COMMENT ON VIEW student_learning_progress IS '学生在各课程中的学习进度追踪视图';

-- =============================================
-- 4. 用户角色信息视图
-- =============================================

CREATE VIEW user_roles_info AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.first_name || ' ' || u.last_name AS full_name,
    u.is_active,
    STRING_AGG(r.role_name, ', ' ORDER BY r.role_name) AS roles,
    u.created_at,
    u.last_login
FROM users u
LEFT JOIN user_roles ur ON u.user_id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.role_id
GROUP BY u.user_id, u.username, u.email, u.first_name, u.last_name, 
         u.is_active, u.created_at, u.last_login;

COMMENT ON VIEW user_roles_info IS '用户及其角色信息汇总视图';

-- =============================================
-- 5. 考试详情视图
-- =============================================

CREATE VIEW exam_details AS
SELECT 
    e.exam_id,
    e.exam_title,
    e.description,
    e.exam_type,
    c.course_id,
    c.course_name,
    u.first_name || ' ' || u.last_name AS created_by_name,
    e.duration AS duration_minutes,
    e.total_marks,
    e.passing_marks,
    e.start_time,
    e.end_time,
    e.is_active,
    e.allow_review,
    e.shuffle_questions,
    COUNT(DISTINCT q.question_id) AS total_questions,
    COUNT(DISTINCT CASE WHEN q.question_type = 'MCQ' THEN q.question_id END) AS mcq_count,
    COUNT(DISTINCT CASE WHEN q.question_type = 'Short Answer' THEN q.question_id END) AS short_answer_count,
    COUNT(DISTINCT ea.attempt_id) AS total_attempts,
    COUNT(DISTINCT ea.user_id) AS unique_students_attempted
FROM exams e
JOIN courses c ON e.course_id = c.course_id
JOIN users u ON e.created_by = u.user_id
LEFT JOIN questions q ON e.exam_id = q.exam_id
LEFT JOIN exam_attempts ea ON e.exam_id = ea.exam_id
GROUP BY e.exam_id, e.exam_title, e.description, e.exam_type, c.course_id, 
         c.course_name, u.first_name, u.last_name, e.duration, e.total_marks, 
         e.passing_marks, e.start_time, e.end_time, e.is_active, 
         e.allow_review, e.shuffle_questions;

COMMENT ON VIEW exam_details IS '考试详细信息视图，包含题目统计和参与情况';

-- =============================================
-- 6. 热门视频视图
-- =============================================

CREATE VIEW popular_videos AS
SELECT 
    v.video_id,
    v.title,
    c.course_id,
    c.course_name,
    v.view_count,
    v.duration,
    COUNT(DISTINCT vv.user_id) AS unique_viewers,
    ROUND(AVG(vv.completion_percentage), 2) AS avg_completion_percentage,
    v.uploaded_at,
    u.first_name || ' ' || u.last_name AS uploaded_by_name
FROM videos v
JOIN courses c ON v.course_id = c.course_id
JOIN users u ON v.uploaded_by = u.user_id
LEFT JOIN video_views vv ON v.video_id = vv.video_id
WHERE v.is_active = TRUE
GROUP BY v.video_id, v.title, c.course_id, c.course_name, v.view_count, 
         v.duration, v.uploaded_at, u.first_name, u.last_name
ORDER BY v.view_count DESC;

COMMENT ON VIEW popular_videos IS '热门视频排行视图，按浏览次数排序';

-- 完成视图创建
SELECT 'All views created successfully!' AS status;