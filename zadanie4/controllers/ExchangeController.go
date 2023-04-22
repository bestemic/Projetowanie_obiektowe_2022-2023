package controllers

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"zadanie4/proxy"
)

type ExchangeController struct {
}

func (w *ExchangeController) GetExchange(c echo.Context) error {

	exchangeProxy := proxy.ExchangeProxy{}
	exchangeData, err := exchangeProxy.GetExchange(c)

	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusOK, exchangeData)
}
