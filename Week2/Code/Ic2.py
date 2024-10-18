rainfall = (('JAN', 111.4),
            ('FEB', 126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG', 140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV', 128.4),
            ('DEC', 142.2),
           )
# List comprehension for rainfall greater than 100 mm
high_rainfall = [month_rain for month_rain in rainfall if month_rain[1] > 100]

print("Months and rainfall values greater than 100 mm:", high_rainfall)

# List comprehension for months with rainfall less than 50 mm
low_rainfall_months = [month for month, amount in rainfall if amount < 50]

print("Months with rainfall less than 50 mm:", low_rainfall_months)

# Conventional loop for rainfall greater than 100 mm
high_rainfall_loop = []
for month_rain in rainfall:
    if month_rain[1] > 100:
        high_rainfall_loop.append(month_rain)

print("Months and rainfall values greater than 100 mm (loop):", high_rainfall_loop)

# Conventional loop for months with rainfall less than 50 mm
low_rainfall_months_loop = []
for month, amount in rainfall:
    if amount < 50:
        low_rainfall_months_loop.append(month)

print("Months with rainfall less than 50 mm (loop):", low_rainfall_months_loop)
