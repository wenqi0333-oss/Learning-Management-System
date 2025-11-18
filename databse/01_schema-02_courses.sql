-- =============================================
-- 01_schema/02_courses.sql - 课程相关表
-- =============================================

-- 4. 课程表 (Courses)
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    description TEXT,
    created_by INTEGER NOT NULL REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    start_date DATE,
    end_date DATE
);

-- 5. 课程注册表 (Course_Enrollments)
CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_status VARCHAR(20) DEFAULT 'In Progress' CHECK (completion_status IN ('Not Started', 'In Progress', 'Completed')),
    completion_date TIMESTAMP,
    UNIQUE(course_id, user_id)
);

-- 添加注释
COMMENT ON TABLE courses IS '课程信息表';
COMMENT ON TABLE course_enrollments IS '学生选课记录表';

COMMENT ON COLUMN courses.course_code IS '课程代码，用于标识课程的唯一编号';
COMMENT ON COLUMN courses.created_by IS '课程创建者(通常是Trainer)';
COMMENT ON COLUMN courses.is_active IS '课程是否活跃，用于归档旧课程';
COMMENT ON COLUMN course_enrollments.completion_status IS '完成状态:Not Started, In Progress, Completed';