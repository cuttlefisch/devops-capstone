package settings

import (
"github.com/spf13/viper"
"strings"
)

var Key string = "CONFIGURATION"

type IConfiguration interface {
	App() IAppConfiguration
	Postgres() IPostgresConfiguration
}

type Configuration struct {
	app      IAppConfiguration
	postgres IPostgresConfiguration
}

func NewConfiguration() *Configuration {
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	return &Configuration{
		app:      NewAppConfiguration(),
		postgres: NewPostgresConfiguration(),
	}
}
func (config Configuration) App() IAppConfiguration {
	return config.app
}

func (config Configuration) Postgres() IPostgresConfiguration {
	return config.postgres
}
