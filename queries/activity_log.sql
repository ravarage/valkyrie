-- name: GetActivityLogEntry :one
SELECT * FROM activity_log
WHERE id = $1 LIMIT 1;

-- name: ListActivityLog :many
SELECT * FROM activity_log
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListUserActivityLog :many
SELECT * FROM activity_log
WHERE user_id = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListActivityByAction :many
SELECT * FROM activity_log
WHERE action = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListActivityByTarget :many
SELECT * FROM activity_log
WHERE target_type = $1 AND target_id = $2
ORDER BY created_at DESC
LIMIT $3 OFFSET $4;

-- name: CreateActivityLogEntry :one
INSERT INTO activity_log (
    user_id,
    action,
    target_type,
    target_id,
    details,
    ip_address,
    user_agent
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;

-- name: DeleteOldActivityLog :exec
DELETE FROM activity_log
WHERE created_at < $1;