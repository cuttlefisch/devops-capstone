package graph

import (
	"context"
	"fmt"
	"todo-backend/db"
	"todo-backend/settings"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	database *db.Database
}

func NewResolver(cfg *settings.Configuration) (*Resolver, error) {
	connString := fmt.Sprintf(
		"postgres://%s:%s@%s/%s",
		cfg.Postgres().Username(),
		cfg.Postgres().Password(),
		cfg.Postgres().Address(),
		cfg.Postgres().DB(),
	)

	ctx := context.Background()
	conn, err := db.NewDatabase(ctx, connString)
	if err != nil {
		return nil, err
	}

	return &Resolver{database: conn}, nil
}
