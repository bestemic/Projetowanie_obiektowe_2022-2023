package proxy

import (
	"encoding/json"
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
	"io"
	"net/http"
	"strings"
	"time"
	"zadanie4/database/models"
)

type ExchangeProxy struct {
}

func (w *ExchangeProxy) GetExchange(c echo.Context) (*models.Exchange, error) {

	db := c.Get("db").(*gorm.DB)
	currentTime := time.Now()
	days := 0
	code := c.Param("code")

	for {
		var exchange models.Exchange
		date := currentTime.AddDate(0, 0, -days).Format("2006-01-02")

		db.Where("currency = ? AND date = ?", strings.ToUpper(code), date).First(&exchange)

		if exchange.ID != 0 {
			return &exchange, nil
		}

		exchangeApi, err := executeRequest(code, date)

		if err == nil {
			exchange = models.Exchange{Currency: strings.ToUpper(exchangeApi.Code), Value: exchangeApi.Rates[0].Mid, Date: exchangeApi.Rates[0].EffectiveDate}
			db.Create(&exchange)

			return &exchange, nil
		}

		days++
	}
}

func executeRequest(code string, date string) (*models.ExchangeApi, error) {
	req, err := http.NewRequest(http.MethodGet, "https://api.nbp.pl/api/exchangerates/rates/a/"+code+"/"+date, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0")
	req.Header.Set("Accept", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var exchangeApi models.ExchangeApi
	err = json.Unmarshal(body, &exchangeApi)

	if err != nil {
		return nil, err
	}

	return &exchangeApi, nil
}
