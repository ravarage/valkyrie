-- name: GetSession :one
SELECT * FROM user_sessions
WHERE id = $1 AND created_at = $2
LIMIT 1;

-- name: GetSessionByToken :one
SELECT * FROM user_sessions
WHERE token = $1 AND expires_at > NOW()
LIMIT 1;

-- name: ListUserSessions :many
SELECT * FROM user_sessions
WHERE user_id = $1 AND expires_at > NOW()
ORDER BY created_at DESC;

-- name: CreateSession :one
INSERT INTO user_sessions (
    user_id,
    token,
    expires_at
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: DeleteSession :exec
DELETE FROM user_sessions
WHERE token = $1;

-- name: DeleteExpiredSessions :exec
DELETE FROM user_sessions
WHERE expires_at < NOW();

-- name: DeleteUserSessions :exec
DELETE FROM user_sessions
WHERE user_id = $1;

-- name: UpdateSessionExpiry :one
UPDATE user_sessions
SET expires_at = $2
WHERE token = $1
RETURNING *;