//go:build acceptance
// +build acceptance

package acceptance

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGetMany(t *testing.T) {
	c, err := NewClient()
	assert.Nil(t, err)

	expectedCount := 5

	var resp getManyTodoResponse
	var titles []string
	var ids []string

	for i := 0; i < expectedCount; i++ {
		todo := Create(c)
		titles = append(titles, todo.Title)
		ids = append(titles, todo.ID)
	}

	c.MustPost(getManyTodoTemplate, &resp)

	t.Run("correct titles should be returned", func(t *testing.T) {
		var actual []string
		for _, edge := range resp.Todos.Edges {
			actual = append(actual, edge.Node.Title)
		}
		assert.Subset(t, actual, titles)
	})

	t.Cleanup(func() {
		for _, id := range ids {
			LogCleanupError(t, Delete(c, id))
		}
	})
}
