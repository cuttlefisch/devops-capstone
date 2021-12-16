package settings

import (
	"github.com/spf13/viper"
)

type IPostgresConfiguration interface {
	Address() string
	Username() string
	Password() string
	DB() string
}

const (
	postgresKey         = "postgres."
	postgresAddressKey  = postgresKey + "address"
	postgresUsernameKey = postgresKey + "username"
	postgresPasswordKey = postgresKey + "password"
	postgresDBKey       = postgresKey + "db"
)

type PostgresConfiguration struct{}

func NewPostgresConfiguration() *PostgresConfiguration {
	viper.SetDefault(postgresAddressKey, "localhost:5432")
	viper.SetDefault(postgresUsernameKey, "postgres")
	viper.SetDefault(postgresPasswordKey, "postgres")
	viper.SetDefault(postgresDBKey, "todos")
	return &PostgresConfiguration{}
}

func (rds PostgresConfiguration) Address() string {
	return viper.GetString(postgresAddressKey)
}

func (rds PostgresConfiguration) Username() string {
	return viper.GetString(postgresUsernameKey)
}

func (rds PostgresConfiguration) Password() string {
	return viper.GetString(postgresPasswordKey)
}

func (rds PostgresConfiguration) DB() string {
	return viper.GetString(postgresDBKey)
}
