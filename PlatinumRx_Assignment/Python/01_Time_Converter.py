def convert_minutes(minutes):
    hours = minutes // 60
    remaining = minutes % 60
    return f"{hours} hrs {remaining} minutes"


minutes = int(input("Enter minutes: "))

print(convert_minutes(minutes))