package models

type ExchangeApi struct {
	Table    string
	Currency string
	Code     string
	Rates    []Rate
}

type Rate struct {
	No            string
	EffectiveDate string
	Mid           float32
}
