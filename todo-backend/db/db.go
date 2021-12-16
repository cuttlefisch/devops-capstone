package db

import (
	"context"
	"todo-backend/graph/model"

	"github.com/jackc/pgx/v4/pgxpool"
)

type Database struct {
	connection *pgxpool.Pool
	url        string
}

func NewDatabase(ctx context.Context, url string) (*Database, error) {
	connection, err := pgxpool.Connect(ctx, url)
	if err != nil {
		return nil, err
	}

	return &Database{
		url:        url,
		connection: connection,
	}, nil
}

func (db *Database) Close() {
	db.connection.Close()
}

func (db *Database) GetAllTodo(ctx context.Context) ([]model.Todo, error) {
	rows, _ := db.connection.Query(ctx, "SELECT id, title, completed FROM todos")

	var output []model.Todo

	for rows.Next() {
		var id string
		var title string
		var completed bool

		if err := rows.Scan(&id, &title, &completed); err != nil {
			return []model.Todo{}, err
		}

		output = append(output, model.Todo{
			ID:        id,
			Title:     title,
			Completed: completed,
		})
	}

	return output, nil
}

func (db *Database) GetTodo(ctx context.Context, id string) (*model.Todo, error) {
	row := db.connection.QueryRow(ctx, "SELECT title, completed FROM todos WHERE id=$1", id)

	var title string
	var completed bool
	if err := row.Scan(&title, &completed); err != nil {
		return nil, err
	}

	return &model.Todo{
		ID:        id,
		Title:     title,
		Completed: completed,
	}, nil
}

func (db *Database) RemoveTodo(ctx context.Context, id string) error {
	_, err := db.connection.Exec(ctx, "DELETE FROM todos WHERE id=$1 ", id)
	return err
}

func (db *Database) InsertTodo(ctx context.Context, todo *model.Todo) error {
	_, err := db.connection.Exec(ctx, "INSERT INTO todos (id, title, completed) VALUES($1, $2, $3)", todo.ID, todo.Title, todo.Completed)
	return err
}

func (db Database) UpdateTodo(ctx context.Context, todo *model.Todo) error {
	_, err := db.connection.Exec(ctx, "UPDATE todos SET title=$2, completed=$3 WHERE id=$1", todo.ID, todo.Title, todo.Completed)
	return err
}
