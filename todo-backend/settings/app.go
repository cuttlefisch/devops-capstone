package settings

import (
	"github.com/spf13/viper"
)

type IAppConfiguration interface {
	BindAddress() string
	Version() string
}

const (
	appKey              = "app."
	appVersionKey       = appKey + "version"
	appBindAddressKey   = appKey + "bind_address"
)

var version string

func SetAppVersion(appVersion string) {
	version = appVersion
}

type AppConfiguration struct{}

func NewAppConfiguration() *AppConfiguration {
	defaultAddress := "127.0.0.1:8080"
	viper.Set(appVersionKey, version)
	viper.SetDefault(appBindAddressKey, defaultAddress)
	return &AppConfiguration{}
}

func (app AppConfiguration) BindAddress() string {
	return viper.GetString(appBindAddressKey)
}

func (app AppConfiguration) Version() string {
	return viper.GetString(appVersionKey)
}
