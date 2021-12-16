package acceptance

import (
	"testing"
	"todo-backend/graph"
	"todo-backend/graph/generated"
	"todo-backend/graph/model"
	"todo-backend/settings"

	"github.com/99designs/gqlgen/client"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/google/uuid"
)

func NewClient() (*client.Client, error) {
	res, err := graph.NewResolver(settings.NewConfiguration())
	if err != nil {
		return nil, err
	}
	cfg := generated.Config{Resolvers: res}
	return client.New(handler.NewDefaultServer(generated.NewExecutableSchema(cfg))), nil
}

func Create(c *client.Client) model.Todo {
	title := uuid.NewString()
	var resp createTodoResponse
	c.MustPost(createTodoTemplate, &resp, client.Var("title", title))
	return resp.CreateTodo
}

func MustDelete(c *client.Client, id string) {
	var resp deleteTodoResponse
	c.MustPost(deleteTodoTemplate, &resp, client.Var("id", id))
}

func Delete(c *client.Client, id string) error {
	var resp deleteTodoResponse
	return c.Post(deleteTodoTemplate, &resp, client.Var("id", id))
}

func GetAll(c *client.Client) (todos []model.Todo) {
	var resp getManyTodoResponse

	c.MustPost(getManyTodoTemplate, &resp)
	for _, edge := range resp.Todos.Edges {
		todos = append(todos, *edge.Node)
	}

	return
}

func LogCleanupError(t *testing.T, err error) {
	if err != nil {
		t.Logf("Cleanup: %s\n", err.Error())
	}
}
