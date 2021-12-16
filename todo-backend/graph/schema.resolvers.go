package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"errors"
	"todo-backend/graph/generated"
	"todo-backend/graph/model"

	"github.com/google/uuid"
)

func (r *mutationResolver) CreateTodo(ctx context.Context, input model.NewTodo) (*model.Todo, error) {
	if len(input.Title) <= 0 {
		return nil, errors.New("todo 'title' required")
	}

	id := uuid.NewString()

	next := &model.Todo{
		ID:        id,
		Title:     input.Title,
		Completed: false,
	}

	err := r.database.InsertTodo(ctx, next)
	if err != nil {
		return nil, err
	}
	return next, nil
}

func (r *mutationResolver) UpdateTodo(ctx context.Context, id string, input model.UpdateTodo) (*model.Todo, error) {
	next, err := r.database.GetTodo(ctx, id)
	if err != nil {
		return nil, err
	}

	if input.Title != nil {
		next.Title = *input.Title
	}
	if input.Completed != nil {
		next.Completed = *input.Completed
	}

	err = r.database.UpdateTodo(ctx, next)
	return next, err
}

func (r *mutationResolver) DeleteTodo(ctx context.Context, id string) (*model.Todo, error) {
	todo, err := r.database.GetTodo(ctx, id)
	if err != nil {
		return nil, err
	}
	err = r.database.RemoveTodo(ctx, id)

	return todo, err
}

func (r *queryResolver) Todo(ctx context.Context, id string) (*model.Todo, error) {
	return r.database.GetTodo(ctx, id)
}

func (r *queryResolver) Todos(ctx context.Context, first *int, after *string) (*model.TodoConnection, error) {
	todos, err := r.database.GetAllTodo(ctx)
	if err != nil {
		return nil, err
	}

	var edges []*model.TodoEdge
	for _, todo := range todos {
		td := todo
		edges = append(edges, &model.TodoEdge{
			Node:   &td,
			Cursor: todo.ID,
		})
	}

	defaultHasNextPage := false
	totalCount := len(todos)

	return &model.TodoConnection{
		Edges: edges,
		PageInfo: &model.PageInfo{
			StartCursor: "",
			EndCursor:   "",
			HasNextPage: &defaultHasNextPage,
		},
		TotalCount: &totalCount,
	}, nil
}

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
