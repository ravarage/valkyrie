-- name: GetFile :one
SELECT * FROM files
WHERE id = $1 LIMIT 1;

-- name: ListFiles :many
SELECT * FROM files
ORDER BY id;

-- name: ListFilesByFolder :many
SELECT * FROM files
WHERE folder_id = $1
ORDER BY id;

-- name: CreateFile :one
INSERT INTO files (
    name,
    location,
    folder_id
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: UpdateFile :one
UPDATE files
SET name = $2,
    location = $3,
    folder_id = $4
WHERE id = $1
RETURNING *;

-- name: DeleteFile :exec
DELETE FROM files
WHERE id = $1;

-- name: GetFileWithMetadata :one
SELECT f.*, fm.file_size, fm.mime_type, fm.created_at, fm.modified_at
FROM files f
LEFT JOIN file_metadata fm ON f.id = fm.file_id
WHERE f.id = $1
LIMIT 1;

-- name: GetFilePermissionsByFileId :many
SELECT * FROM file_permissions
WHERE file_id = $1
ORDER BY id;

-- name: GetFileVersionsByFileId :many
SELECT * FROM file_versions
WHERE file_id = $1
ORDER BY version DESC;

-- name: GetLatestFileVersionByFileId :one
SELECT * FROM file_versions
WHERE file_id = $1
ORDER BY version DESC
LIMIT 1;

-- name: ListFilesByTag :many
SELECT f.*
FROM files f
JOIN file_tags ft ON f.id = ft.file_id
WHERE ft.tag_id = $1
ORDER BY f.id;