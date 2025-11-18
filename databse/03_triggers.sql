-- =============================================
-- 03_triggers.sql - 触发器和函数
-- =============================================

-- =============================================
-- 1. 自动更新 updated_at 时间戳
-- =============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 应用到 users 表
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 应用到 courses 表
CREATE TRIGGER update_courses_updated_at 
    BEFORE UPDATE ON courses
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 2. 自动计算考试总分
-- =============================================

CREATE OR REPLACE FUNCTION calculate_exam_total_marks()
RETURNS TRIGGER AS $$
BEGIN
    -- 当题目被添加或修改时，更新考试的总分
    UPDATE exams 
    SET total_marks = (
        SELECT COALESCE(SUM(marks), 0) 
        FROM questions 
        WHERE exam_id = NEW.exam_id
    )
    WHERE exam_id = NEW.exam_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_exam_total_marks_on_insert
    AFTER INSERT ON questions
    FOR EACH ROW
    EXECUTE FUNCTION calculate_exam_total_marks();

CREATE TRIGGER update_exam_total_marks_on_update
    AFTER UPDATE ON questions
    FOR EACH ROW
    WHEN (OLD.marks IS DISTINCT FROM NEW.marks)
    EXECUTE FUNCTION calculate_exam_total_marks();

CREATE TRIGGER update_exam_total_marks_on_delete
    AFTER DELETE ON questions
    FOR EACH ROW
    EXECUTE FUNCTION calculate_exam_total_marks();

-- =============================================
-- 3. 自动评分选择题
-- =============================================

CREATE OR REPLACE FUNCTION auto_grade_mcq()
RETURNS TRIGGER AS $$
BEGIN
    -- 检查选择题答案是否正确
    IF NEW.selected_option_id IS NOT NULL THEN
        SELECT 
            CASE WHEN mo.is_correct THEN q.marks ELSE 0 END,
            mo.is_correct
        INTO NEW.marks_obtained, NEW.is_correct
        FROM mcq_options mo
        JOIN questions q ON mo.question_id = q.question_id
        WHERE mo.option_id = NEW.selected_option_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grade_mcq_answer
    BEFORE INSERT OR UPDATE ON student_answers
    FOR EACH ROW
    WHEN (NEW.selected_option_id IS NOT NULL)
    EXECUTE FUNCTION auto_grade_mcq();

-- =============================================
-- 4. 计算考试尝试的总分
-- =============================================

CREATE OR REPLACE FUNCTION calculate_attempt_score()
RETURNS TRIGGER AS $$
DECLARE
    v_total_score DECIMAL(5,2);
    v_total_marks DECIMAL(5,2);
    v_passing_marks DECIMAL(5,2);
BEGIN
    -- 计算学生在该次考试尝试中获得的总分
    SELECT 
        COALESCE(SUM(sa.marks_obtained), 0),
        e.total_marks,
        e.passing_marks
    INTO v_total_score, v_total_marks, v_passing_marks
    FROM student_answers sa
    JOIN questions q ON sa.question_id = q.question_id
    JOIN exams e ON q.exam_id = e.exam_id
    WHERE sa.attempt_id = NEW.attempt_id
    GROUP BY e.total_marks, e.passing_marks;
    
    -- 更新考试尝试记录
    UPDATE exam_attempts
    SET 
        score = v_total_score,
        total_marks = v_total_marks,
        is_passed = (v_total_score >= v_passing_marks)
    WHERE attempt_id = NEW.attempt_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_attempt_score
    AFTER INSERT OR UPDATE ON student_answers
    FOR EACH ROW
    WHEN (NEW.marks_obtained IS NOT NULL)
    EXECUTE FUNCTION calculate_attempt_score();

-- =============================================
-- 5. 更新视频浏览次数
-- =============================================

CREATE OR REPLACE FUNCTION increment_video_view_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE videos
    SET view_count = view_count + 1
    WHERE video_id = NEW.video_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_view_count
    AFTER INSERT ON video_views
    FOR EACH ROW
    EXECUTE FUNCTION increment_video_view_count();

-- =============================================
-- 6. 更新材料下载次数
-- =============================================

CREATE OR REPLACE FUNCTION increment_download_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE learning_materials
    SET download_count = download_count + 1
    WHERE material_id = NEW.material_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_material_download_count
    AFTER INSERT ON material_downloads
    FOR EACH ROW
    EXECUTE FUNCTION increment_download_count();

-- =============================================
-- 7. 自动设置课程完成日期
-- =============================================

CREATE OR REPLACE FUNCTION set_course_completion_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completion_status = 'Completed' AND OLD.completion_status != 'Completed' THEN
        NEW.completion_date = CURRENT_TIMESTAMP;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_set_completion_date
    BEFORE UPDATE ON course_enrollments
    FOR EACH ROW
    EXECUTE FUNCTION set_course_completion_date();

-- 完成触发器创建
SELECT 'All triggers and functions created successfully!' AS status;