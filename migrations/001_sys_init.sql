-- +migrate Up
CREATE TABLE roles
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(20),
    description VARCHAR(150),
    permissions TEXT
);

CREATE TABLE users
(
    id       SERIAL PRIMARY KEY,
    username TEXT    NOT NULL,
    password TEXT    NOT NULL,
    email    TEXT UNIQUE,
    role_id  INTEGER REFERENCES roles (id) ON DELETE SET NULL,
    status   VARCHAR(10)
);

CREATE TABLE t_types
(
    id          SERIAL PRIMARY KEY,
    type_key    VARCHAR(20) UNIQUE,
    name        VARCHAR(30),
    description VARCHAR(150)
);

CREATE TABLE categories
(
    id          SERIAL PRIMARY KEY,
    cat_key     VARCHAR(20) UNIQUE,
    name        VARCHAR(30),
    description VARCHAR(150),
    t_type_id   INTEGER REFERENCES t_types (id) ON DELETE SET NULL,
    category_id INTEGER REFERENCES categories (id) ON DELETE SET NULL
);

CREATE TABLE format
(
    id    SERIAL PRIMARY KEY,
    codec VARCHAR(20)
);

CREATE TABLE folder
(
    id     SERIAL PRIMARY KEY,
    folder TEXT
);

CREATE TABLE folder_attributes
(
    id        SERIAL PRIMARY KEY,
    folder_id INTEGER REFERENCES folder (id) ON DELETE SET NULL,
    detail    TEXT
);

CREATE TABLE codec
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE files
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(255),
    location  TEXT,
    folder_id INTEGER REFERENCES folder (id) ON DELETE SET NULL
);

CREATE TABLE file_attributes
(
    id      SERIAL PRIMARY KEY,
    file_id INTEGER REFERENCES files (id) ON DELETE SET NULL,
    codec_id INTEGER REFERENCES codec (id) ON DELETE SET NULL,
    format  VARCHAR(20)
);


-- File metadata (size, creation date, etc.)
CREATE TABLE file_metadata
(
    id           SERIAL PRIMARY KEY,
    file_id      INTEGER REFERENCES files (id) ON DELETE CASCADE,
    file_size    BIGINT,
    mime_type    VARCHAR(100),
    checksum     VARCHAR(64), -- for integrity checking
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accessed_at  TIMESTAMP
);

-- Tags for flexible categorization
CREATE TABLE tags
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50) UNIQUE NOT NULL,
    color       VARCHAR(7), -- hex color code
    description TEXT,
    created_by  INTEGER REFERENCES users (id) ON DELETE SET NULL
);

-- Many-to-many relationship between files and tags
CREATE TABLE file_tags
(
    file_id INTEGER REFERENCES files (id) ON DELETE CASCADE,
    tag_id  INTEGER REFERENCES tags (id) ON DELETE CASCADE,
    PRIMARY KEY (file_id, tag_id)
);

-- File sharing/permissions
CREATE TABLE file_permissions
(
    id          SERIAL PRIMARY KEY,
    file_id     INTEGER REFERENCES files (id) ON DELETE CASCADE,
    user_id     INTEGER REFERENCES users (id) ON DELETE CASCADE,
    permission  VARCHAR(20) NOT NULL, -- 'read', 'write', 'delete', 'share'
    granted_by  INTEGER REFERENCES users (id) ON DELETE SET NULL,
    granted_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- File versions/history
CREATE TABLE file_versions
(
    id           SERIAL PRIMARY KEY,
    file_id      INTEGER REFERENCES files (id) ON DELETE CASCADE,
    version      INTEGER NOT NULL,
    location     TEXT NOT NULL,
    file_size    BIGINT,
    created_by   INTEGER REFERENCES users (id) ON DELETE SET NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment      TEXT
);

-- Activity/audit log
CREATE TABLE activity_log
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER REFERENCES users (id) ON DELETE SET NULL,
    action      VARCHAR(50) NOT NULL, -- 'upload', 'download', 'delete', 'share', etc.
    target_type VARCHAR(20) NOT NULL, -- 'file', 'folder', 'user', etc.
    target_id   INTEGER,
    details     JSONB, -- flexible details storage
    ip_address  INET,
    user_agent  TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Folder permissions (if folders need separate permissions)
CREATE TABLE folder_permissions
(
    id          SERIAL PRIMARY KEY,
    folder_id   INTEGER REFERENCES folder (id) ON DELETE CASCADE,
    user_id     INTEGER REFERENCES users (id) ON DELETE CASCADE,
    permission  VARCHAR(20) NOT NULL,
    granted_by  INTEGER REFERENCES users (id) ON DELETE SET NULL,
    granted_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- File comments/annotations
CREATE TABLE file_comments
(
    id         SERIAL PRIMARY KEY,
    file_id    INTEGER REFERENCES files (id) ON DELETE CASCADE,
    user_id    INTEGER REFERENCES users (id) ON DELETE CASCADE,
    comment    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Favorites/bookmarks
CREATE TABLE user_favorites
(
    user_id INTEGER REFERENCES users (id) ON DELETE CASCADE,
    file_id INTEGER REFERENCES files (id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, file_id)
);

-- Storage locations/drives (if you have multiple storage backends)
CREATE TABLE storage_locations
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    type        VARCHAR(20) NOT NULL, -- 'local', 's3', 'ftp', etc.
    config      JSONB, -- connection details, credentials, etc.
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Scheduled tasks (cleanup, backups, etc.)
CREATE TABLE scheduled_tasks
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    type        VARCHAR(50) NOT NULL,
    schedule    VARCHAR(100), -- cron expression
    last_run    TIMESTAMP,
    next_run    TIMESTAMP,
    status      VARCHAR(20) DEFAULT 'active',
    config      JSONB,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- +migrate Down
-- +migrate Down
-- Drop tables in reverse dependency order to avoid foreign key constraint errors

DROP TABLE IF EXISTS scheduled_tasks;
DROP TABLE IF EXISTS storage_locations;
DROP TABLE IF EXISTS user_favorites;
DROP TABLE IF EXISTS file_comments;
DROP TABLE IF EXISTS folder_permissions;
DROP TABLE IF EXISTS activity_log;
DROP TABLE IF EXISTS file_versions;
DROP TABLE IF EXISTS file_permissions;
DROP TABLE IF EXISTS file_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS file_metadata;

DROP TABLE IF EXISTS file_attributes;
DROP TABLE IF EXISTS files;
DROP TABLE IF EXISTS codec;
DROP TABLE IF EXISTS folder_attributes;
DROP TABLE IF EXISTS folder;
DROP TABLE IF EXISTS format;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS t_types;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;