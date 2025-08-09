-- name: GetFolderPermission :one
SELECT * FROM folder_permissions
WHERE id = $1 LIMIT 1;

-- name: GetUserFolderPermission :one
SELECT * FROM folder_permissions
WHERE folder_id = $1 AND user_id = $2
LIMIT 1;

-- name: ListFolderPermissions :many
SELECT * FROM folder_permissions
WHERE folder_id = $1
ORDER BY id;

-- name: ListUserFolderPermissions :many
SELECT * FROM folder_permissions
WHERE user_id = $1
ORDER BY id;

-- name: CreateFolderPermission :one
INSERT INTO folder_permissions (
    folder_id,
    user_id,
    permission,
    granted_by
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateFolderPermission :one
UPDATE folder_permissions
SET permission = $2
WHERE id = $1
RETURNING *;

-- name: DeleteFolderPermission :exec
DELETE FROM folder_permissions
WHERE id = $1;

-- name: DeleteUserFolderPermission :exec
DELETE FROM folder_permissions
WHERE folder_id = $1 AND user_id = $2;

-- name: CheckUserHasFolderPermission :one
SELECT EXISTS (
    SELECT 1 FROM folder_permissions
    WHERE folder_id = $1 
    AND user_id = $2 
    AND permission = $3
) AS has_permission;