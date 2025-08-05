-- +migrate Up
CREATE TABLE user_sessions (
                               id         BIGSERIAL,
                               user_id    INTEGER REFERENCES users (id) ON DELETE CASCADE,
                               token      VARCHAR(255) NOT NULL,
                               expires_at TIMESTAMP NOT NULL,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE UNIQUE INDEX idx_user_sessions_token ON user_sessions (token, created_at);
CREATE INDEX idx_user_sessions_user_id ON user_sessions (user_id);
CREATE INDEX idx_user_sessions_expires_at ON user_sessions (expires_at);

-- Static partitions only (you can add more later)
CREATE TABLE user_sessions_2025_08 PARTITION OF user_sessions
    FOR VALUES FROM ('2025-08-01') TO ('2025-09-01');

CREATE TABLE user_sessions_2025_09 PARTITION OF user_sessions
    FOR VALUES FROM ('2025-09-01') TO ('2025-10-01');

CREATE TABLE user_sessions_2025_10 PARTITION OF user_sessions
    FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');

CREATE TABLE user_sessions_2025_11 PARTITION OF user_sessions
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

CREATE TABLE user_sessions_2025_12 PARTITION OF user_sessions
    FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

CREATE TABLE user_sessions_2026_01 PARTITION OF user_sessions
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

CREATE TABLE user_sessions_default PARTITION OF user_sessions DEFAULT;

-- +migrate Down
DROP TABLE IF EXISTS user_sessions_default;
DROP TABLE IF EXISTS user_sessions_2026_01;
DROP TABLE IF EXISTS user_sessions_2025_12;
DROP TABLE IF EXISTS user_sessions_2025_11;
DROP TABLE IF EXISTS user_sessions_2025_10;
DROP TABLE IF EXISTS user_sessions_2025_09;
DROP TABLE IF EXISTS user_sessions_2025_08;
DROP TABLE IF EXISTS user_sessions;
