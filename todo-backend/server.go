package main

import (
	"log"
	"todo-backend/graph"
	"todo-backend/graph/generated"
	"todo-backend/settings"

	"github.com/gin-gonic/gin"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
)

var version string = "0.0.0"

func main() {
	settings.SetAppVersion(version)
	cfg := settings.NewConfiguration()

	r := gin.Default()
	r.Use(CORSMiddleware())
	r.GET("/health-check", healthCheckHandler(cfg))
	r.POST("/query", graphqlHandler(cfg))
	r.GET("/", playgroundHandler())

	log.Printf("Running todo backend version '%s'\n", version)
	handleError(r.Run(cfg.App().BindAddress()))
}

func graphqlHandler(cfg *settings.Configuration) gin.HandlerFunc {
	res, err := graph.NewResolver(cfg)
	handleError(err)

	h := handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: res}))

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func healthCheckHandler(cfg *settings.Configuration) gin.HandlerFunc {

	return func(c *gin.Context) {
		c.JSON(200, struct {
			App     string `json:"app"`
			Version string `json:"version"`
		}{
			App:     "todo",
			Version: cfg.App().Version(),
		})
	}
}

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "*")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

func playgroundHandler() gin.HandlerFunc {
	h := playground.Handler("GraphQL", "/query")

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func handleError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
