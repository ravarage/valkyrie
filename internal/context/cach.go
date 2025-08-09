package context

import (
	"context"
	"fmt"
	"reflect"
	"time"

	"github.com/goccy/go-json"
)

func (c *Context) Set(key string, data any, ttl int64) error {
	text, err := json.Marshal(data)
	if err != nil {
		return err
	}
	err = c.RDB.Set(context.Background(), key, text, time.Duration(ttl)*time.Second).Err()
	if err != nil {
		return err
	}
	return nil
}

func (c *Context) Get(key string, data any) error {
	// Check data is a pointer, because json.Unmarshal requires it
	if reflect.TypeOf(data).Kind() != reflect.Ptr {
		return fmt.Errorf("data argument must be a pointer")
	}

	val, err := c.RDB.Get(context.Background(), key).Result()
	if err != nil {
		return err
	}

	return json.Unmarshal([]byte(val), data)
}
