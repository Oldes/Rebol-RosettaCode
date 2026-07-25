Rebol [
    title: "Rosetta code: Nth Particular Weekday of the Month"
    file:  %Nth_Particular_Weekday_of_the_Month.r3
    url:   https://rosettacode.org/wiki/Nth_Particular_Weekday_of_the_Month
]

nth-weekday: function [
    "Return the date of the nth occurrence of weekday in month/year, or none"
    year [integer!] month [integer!] weekday [integer!] n [integer!]
][
    date: to date! reduce [year month 1]
    while [date/month == month] [
        if all [
            date/weekday == weekday
            n == (1 + to integer! (date/day - 1) / 7)
        ][
            return date/day
        ]
        date: date + 1
    ]
    none
]

print "    Thanksgiving Day"
print "Year Canadian   American"
print "------------------------"
for year 2020 2029 1 [
    canadian: nth-weekday year 10 1 2  ;; 2nd Monday of October
    american: nth-weekday year 11 4 4  ;; 4th Thursday of November
    printf [4 "  Oct " 2 "    Nov " 2] [year canadian american]
]