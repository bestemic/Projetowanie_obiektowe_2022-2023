package models

import "gorm.io/gorm"

type Exchange struct {
	gorm.Model
	Currency string
	Value    float32
}
