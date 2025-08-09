-- name: GetFileVersion :one
SELECT * FROM file_versions
WHERE id = $1 LIMIT 1;

-- name: GetFileVersionByNumber :one
SELECT * FROM file_versions
WHERE file_id = $1 AND version = $2
LIMIT 1;

-- name: ListFileVersions :many
SELECT * FROM file_versions
WHERE file_id = $1
ORDER BY version DESC;

-- name: GetLatestFileVersion :one
SELECT * FROM file_versions
WHERE file_id = $1
ORDER BY version DESC
LIMIT 1;

-- name: CreateFileVersion :one
INSERT INTO file_versions (
    file_id,
    version,
    location,
    file_size,
    created_by,
    comment
) VALUES (
    $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: DeleteFileVersion :exec
DELETE FROM file_versions
WHERE id = $1;

-- name: DeleteAllFileVersions :exec
DELETE FROM file_versions
WHERE file_id = $1;