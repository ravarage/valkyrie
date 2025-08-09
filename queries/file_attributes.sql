-- name: GetFileAttribute :one
SELECT * FROM file_attributes
WHERE id = $1 LIMIT 1;

-- name: GetFileAttributeByFileID :one
SELECT * FROM file_attributes
WHERE file_id = $1 LIMIT 1;

-- name: ListFileAttributes :many
SELECT * FROM file_attributes
ORDER BY id;

-- name: ListFileAttributesByCodec :many
SELECT * FROM file_attributes
WHERE codec_id = $1
ORDER BY id;

-- name: ListFileAttributesByFormat :many
SELECT * FROM file_attributes
WHERE format = $1
ORDER BY id;

-- name: CreateFileAttribute :one
INSERT INTO file_attributes (
    file_id,
    codec_id,
    format
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: UpdateFileAttribute :one
UPDATE file_attributes
SET codec_id = $2,
    format = $3
WHERE id = $1
RETURNING *;

-- name: DeleteFileAttribute :exec
DELETE FROM file_attributes
WHERE id = $1;

-- name: DeleteFileAttributeByFileID :exec
DELETE FROM file_attributes
WHERE file_id = $1;