-- name: GetUser :one
SELECT *
FROM users
WHERE id = $1
LIMIT 1;

-- name: AllUser :many
select username,
       email,
       role_id,
       status
from users;



-- name: ListUser :many
SELECT username,
       email,
       role_id,
       status
FROM users
WHERE (@username::text IS NULL OR
       username ILIKE '%' || @username || '%' OR
       username % @username)  -- trigram similarity
  AND (@password::text IS NULL OR password LIKE '%' || @password || '%')
  AND (@email::text IS NULL OR
       email ILIKE '%' || @email || '%' OR
       email % @email)  -- trigram similarity
  AND (@role_id::int IS NULL OR role_id = @role_id)
  AND (@status::int IS NULL OR status = @status)
ORDER BY
    CASE
        WHEN @order_by::text = 'username' AND @direction::text = 'asc' THEN username
        END ASC,
    CASE
        WHEN @order_by::text = 'username' AND @direction::text = 'desc' THEN username
        END DESC,
    CASE
        WHEN @order_by::text = 'email' AND @direction::text = 'asc' THEN email
        END ASC,
    CASE
        WHEN @order_by::text = 'email' AND @direction::text = 'desc' THEN email
        END DESC,
    CASE
        WHEN @order_by::text = 'role_id' AND @direction::text = 'asc' THEN role_id
        END ASC,
    CASE
        WHEN @order_by::text = 'role_id' AND @direction::text = 'desc' THEN role_id
        END DESC,
    CASE
        WHEN @order_by::text = 'status' AND @direction::text = 'asc' THEN status
        END ASC,
    CASE
        WHEN @order_by::text = 'status' AND @direction::text = 'desc' THEN status
        END DESC
LIMIT @limit_count::int OFFSET @offset_num::int;

-- name: GetUserByUsername :one
SELECT *
FROM users
WHERE username = $1
LIMIT 1;

-- name: GetUserByEmailOrUsername :one
SELECT *
FROM users
WHERE email = $1
   or username = $2
LIMIT 1;

-- name: ListUsers :many
SELECT *
FROM users
ORDER BY id;

-- name: CreateUser :one
INSERT INTO users (username,
                   password,
                   email,
                   role_id,
                   status)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: UpdateUser :one
UPDATE users
SET username = $2,
    password = $3,
    email    = $4,
    role_id  = $5,
    status   = $6
WHERE id = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE
FROM users
WHERE id = $1;