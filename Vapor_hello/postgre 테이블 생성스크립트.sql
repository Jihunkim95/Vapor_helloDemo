CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

id: 자동으로 증가하는 일련번호 (주 키)
username: 최대 50자의 문자열, 비어 있을 수 없음
email: 최대 255자의 문자열, 비어 있을 수 없음
created_at: 타임스탬프, 기본값은 현재 시간