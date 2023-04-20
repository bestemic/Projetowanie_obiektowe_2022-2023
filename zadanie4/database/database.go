package database

import (
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"zadanie4/database/models"
)

func Connect() *gorm.DB {
	db, err := gorm.Open(sqlite.Open("data.db"))

	if err != nil {
		panic("Failed to connect with database")
	}

	db.AutoMigrate(&models.Exchange{})

	return db
}
