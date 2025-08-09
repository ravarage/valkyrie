-- name: GetScheduledTask :one
SELECT * FROM scheduled_tasks
WHERE id = $1 LIMIT 1;

-- name: GetScheduledTaskByName :one
SELECT * FROM scheduled_tasks
WHERE name = $1 LIMIT 1;

-- name: ListScheduledTasks :many
SELECT * FROM scheduled_tasks
ORDER BY id;

-- name: ListScheduledTasksByType :many
SELECT * FROM scheduled_tasks
WHERE type = $1
ORDER BY id;

-- name: ListActiveScheduledTasks :many
SELECT * FROM scheduled_tasks
WHERE status = 'active'
ORDER BY next_run;

-- name: ListDueScheduledTasks :many
SELECT * FROM scheduled_tasks
WHERE status = 'active' AND next_run <= NOW()
ORDER BY next_run;

-- name: CreateScheduledTask :one
INSERT INTO scheduled_tasks (
    name,
    type,
    schedule,
    next_run,
    status,
    config
) VALUES (
    $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: UpdateScheduledTask :one
UPDATE scheduled_tasks
SET name = $2,
    type = $3,
    schedule = $4,
    next_run = $5,
    status = $6,
    config = $7
WHERE id = $1
RETURNING *;

-- name: UpdateTaskLastRun :one
UPDATE scheduled_tasks
SET last_run = NOW(),
    next_run = $2
WHERE id = $1
RETURNING *;

-- name: ToggleTaskStatus :one
UPDATE scheduled_tasks
SET status = CASE WHEN status = 'active' THEN 'inactive' ELSE 'active' END
WHERE id = $1
RETURNING *;

-- name: DeleteScheduledTask :exec
DELETE FROM scheduled_tasks
WHERE id = $1;