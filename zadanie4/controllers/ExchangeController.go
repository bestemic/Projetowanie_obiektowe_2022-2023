package controllers

import (
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
	"net/http"
	"zadanie4/database/models"
)

type ExchangeController struct {
}

func (w *ExchangeController) GetExchange(c echo.Context) error {

	db := c.Get("db").(*gorm.DB)

	var exchanges []models.Exchange

	db.Find(&exchanges)
	return c.JSON(http.StatusInternalServerError, exchanges)
}
