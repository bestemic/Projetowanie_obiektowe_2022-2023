package main

import (
	"github.com/labstack/echo/v4"
	"zadanie4/controllers"
	"zadanie4/database"
)

func main() {
	e := echo.New()

	db := database.Connect()

	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Set("db", db)
			return next(c)
		}
	})

	exchangeController := controllers.ExchangeController{}

	e.GET("/:code", exchangeController.GetExchange)

	e.Logger.Fatal(e.Start(":1323"))
}
