def remove_duplicates(s):
    seen = set()
    result = []

    for ch in s:
        if ch not in seen:
            seen.add(ch)
            result.append(ch)

    return "".join(result)


user_input = input("Enter a string: ")
print(remove_duplicates(user_input))