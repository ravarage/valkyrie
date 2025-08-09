-- name: GetFilePermission :one
SELECT * FROM file_permissions
WHERE id = $1 LIMIT 1;

-- name: GetUserFilePermission :one
SELECT * FROM file_permissions
WHERE file_id = $1 AND user_id = $2
LIMIT 1;

-- name: ListFilePermissions :many
SELECT * FROM file_permissions
WHERE file_id = $1
ORDER BY id;

-- name: ListUserPermissions :many
SELECT * FROM file_permissions
WHERE user_id = $1
ORDER BY id;

-- name: CreateFilePermission :one
INSERT INTO file_permissions (
    file_id,
    user_id,
    permission,
    granted_by
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateFilePermission :one
UPDATE file_permissions
SET permission = $2
WHERE id = $1
RETURNING *;

-- name: DeleteFilePermission :exec
DELETE FROM file_permissions
WHERE id = $1;

-- name: DeleteUserFilePermission :exec
DELETE FROM file_permissions
WHERE file_id = $1 AND user_id = $2;

-- name: CheckUserHasPermission :one
SELECT EXISTS (
    SELECT 1 FROM file_permissions
    WHERE file_id = $1 
    AND user_id = $2 
    AND permission = $3
) AS has_permission;