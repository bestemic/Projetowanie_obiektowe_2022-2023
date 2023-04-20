package main

import (
	"github.com/labstack/echo/v4"
	"zadanie4/controllers"
	"zadanie4/database"
	"zadanie4/database/models"
)

func main() {
	e := echo.New()

	db := database.Connect()

	exchanges := []*models.Exchange{
		{Currency: "PLN", Value: 1},
		{Currency: "USD", Value: 4.34},
		{Currency: "CHF", Value: 3.15},
	}

	db.Create(exchanges)

	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Set("db", db)
			return next(c)
		}
	})

	exchangeController := controllers.ExchangeController{}

	e.GET("/", exchangeController.GetExchange)

	e.Logger.Fatal(e.Start(":1323"))
}
