-- name: GetFileMetadata :one
SELECT * FROM file_metadata
WHERE file_id = $1 LIMIT 1;

-- name: CreateFileMetadata :one
INSERT INTO file_metadata (
    file_id,
    file_size,
    mime_type,
    checksum,
    created_at,
    modified_at,
    accessed_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;

-- name: UpdateFileMetadata :one
UPDATE file_metadata
SET file_size = $2,
    mime_type = $3,
    checksum = $4,
    modified_at = NOW(),
    accessed_at = $5
WHERE file_id = $1
RETURNING *;

-- name: UpdateFileAccess :one
UPDATE file_metadata
SET accessed_at = NOW()
WHERE file_id = $1
RETURNING *;

-- name: DeleteFileMetadata :exec
DELETE FROM file_metadata
WHERE file_id = $1;

-- name: ListFilesByMimeType :many
SELECT f.* 
FROM files f
JOIN file_metadata fm ON f.id = fm.file_id
WHERE fm.mime_type = $1
ORDER BY f.id;

-- name: ListFilesBySize :many
SELECT f.* 
FROM files f
JOIN file_metadata fm ON f.id = fm.file_id
WHERE fm.file_size > $1 AND fm.file_size < $2
ORDER BY fm.file_size DESC;