//go:build acceptance
// +build acceptance

package acceptance

import (
	"github.com/99designs/gqlgen/client"
	"github.com/stretchr/testify/assert"
	"testing"
	"todo-backend/graph/model"
)

func TestDelete(t *testing.T) {
	c, err := NewClient()
	assert.Nil(t, err)

	createdCount := 5

	var todos []model.Todo
	deletionIndex := 1

	for i := 0; i < createdCount; i++ {
		todos = append(todos, Create(c))
	}

	toDelete := todos[deletionIndex]

	for _, todo := range todos {
		assert.Contains(t, GetAll(c), todo)
	}

	var resp deleteTodoResponse
	c.MustPost(deleteTodoTemplate, &resp, client.Var("id", toDelete.ID))

	t.Run("Deleted todo should not exist", func(t *testing.T) {
		assert.NotContains(t, GetAll(c), toDelete)
	})

	t.Run("Other todo items should not be deleted", func(t *testing.T) {
		for _, todo := range append(todos[:deletionIndex], todos[deletionIndex+1:]...) {
			assert.Contains(t, GetAll(c), todo)
		}
	})

	t.Cleanup(func() {
		for _, todo := range todos {
			LogCleanupError(t, Delete(c, todo.ID))
		}
	})
}
