package utlis

import (
	"fmt"
	"time"
)

// LogFileName returns a log file name in the format:
// what_weeknumber_month_year.log
func LogFileName(what string) string {
	now := time.Now()
	year, week := now.ISOWeek()
	month := int(now.Month())

	return fmt.Sprintf("%s_%02d_%02d_%d.log", what, week, month, year)
}
