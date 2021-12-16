//go:build acceptance
// +build acceptance

package acceptance

import (
	"github.com/99designs/gqlgen/client"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"testing"
	"todo-backend/graph/model"
)


func TestUpdate_TitleAndCompleted(t *testing.T) {
	c, err := NewClient()
	assert.Nil(t, err)

	createdCount := 5
	updateIndex := 2

	var todos []model.Todo

	for i := 0; i < createdCount; i++ {
		todos = append(todos, Create(c))
	}

	for _, todo := range todos {
		assert.Contains(t, GetAll(c), todo)
	}

	todos[updateIndex].Completed = true
	todos[updateIndex].Title = uuid.NewString()

	var resp updateTodoResponse
	c.MustPost(
		updateTodoTemplate,
		&resp,
		client.Var("id", todos[updateIndex].ID),
		client.Var("title", todos[updateIndex].Title),
		client.Var("completed", todos[updateIndex].Completed),
	)

	t.Run("Updated todo should exist", func(t *testing.T) {
		assert.Contains(t, GetAll(c), todos[updateIndex])
	})

	t.Run("Other todo items should not be deleted", func(t *testing.T) {
		for _, todo := range append(todos[:updateIndex], todos[updateIndex+1:]...) {
			assert.Contains(t, GetAll(c), todo)
		}
	})
}

func TestUpdate_TitleOnly(t *testing.T) {
	c, err := NewClient()
	assert.Nil(t, err)

	createdCount := 5
	updateIndex := 2

	var todos []model.Todo

	for i := 0; i < createdCount; i++ {
		todos = append(todos, Create(c))
	}

	for _, todo := range todos {
		assert.Contains(t, GetAll(c), todo)
	}

	todos[updateIndex].Title = uuid.NewString()

	var resp updateTodoResponse
	c.MustPost(
		updateTodoTemplate,
		&resp,
		client.Var("id", todos[updateIndex].ID),
		client.Var("title", todos[updateIndex].Title),
	)

	t.Run("Updated todo should exist", func(t *testing.T) {
		assert.Contains(t, GetAll(c), todos[updateIndex])
	})

	t.Run("Other todo items should not be deleted", func(t *testing.T) {
		for _, todo := range append(todos[:updateIndex], todos[updateIndex+1:]...) {
			assert.Contains(t, GetAll(c), todo)
		}
	})
}

func TestUpdate_CompletedOnly(t *testing.T) {
	c, err := NewClient()
	assert.Nil(t, err)

	createdCount := 5
	updateIndex := 2

	var todos []model.Todo

	for i := 0; i < createdCount; i++ {
		todos = append(todos, Create(c))
	}

	for _, todo := range todos {
		assert.Contains(t, GetAll(c), todo)
	}

	todos[updateIndex].Completed = true

	var resp updateTodoResponse
	c.MustPost(
		updateTodoTemplate,
		&resp,
		client.Var("id", todos[updateIndex].ID),
		client.Var("completed", todos[updateIndex].Completed),
	)

	t.Run("Updated todo should exist", func(t *testing.T) {
		assert.Contains(t, GetAll(c), todos[updateIndex])
	})

	t.Run("Other todo items should not be deleted", func(t *testing.T) {
		for _, todo := range append(todos[:updateIndex], todos[updateIndex+1:]...) {
			assert.Contains(t, GetAll(c), todo)
		}
	})

	t.Cleanup(func() {
		for _, todo := range todos {
			LogCleanupError(t, Delete(c, todo.ID))
		}
	})
}
