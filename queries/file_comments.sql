-- name: GetFileComment :one
SELECT * FROM file_comments
WHERE id = $1 LIMIT 1;

-- name: ListFileComments :many
SELECT * FROM file_comments
WHERE file_id = $1
ORDER BY created_at DESC;

-- name: ListUserComments :many
SELECT * FROM file_comments
WHERE user_id = $1
ORDER BY created_at DESC;

-- name: CreateFileComment :one
INSERT INTO file_comments (
    file_id,
    user_id,
    comment
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: UpdateFileComment :one
UPDATE file_comments
SET comment = $2,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteFileComment :exec
DELETE FROM file_comments
WHERE id = $1;

-- name: DeleteAllFileComments :exec
DELETE FROM file_comments
WHERE file_id = $1;