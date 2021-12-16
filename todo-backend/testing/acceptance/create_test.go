//go:build acceptance
// +build acceptance

package acceptance

import (
	"github.com/99designs/gqlgen/client"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestCreateTodo(t *testing.T) {
	c, err := NewClient()
	assert.Nil(t, err)

	var resp createTodoResponse
	title := "hello world"

	c.MustPost(createTodoTemplate, &resp, client.Var("title", title))

	t.Run("Correct title should be returned", func(t *testing.T) {
		assert.Equal(t, resp.CreateTodo.Title, title)
	})

	t.Run("ID should not be empty", func(t *testing.T) {
		assert.NotEmpty(t, resp.CreateTodo.ID, "expected a non-empty ID")
	})

	t.Cleanup(func() {
		LogCleanupError(t, Delete(c, resp.CreateTodo.ID))
	})
}
