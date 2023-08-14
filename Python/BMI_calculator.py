class Calculator:

    def calculate(self, height, weight):
        BMI = (weight * 703) / (height * height)
        return round(BMI, 2)
    
    def get_details(self):
        name = input("Enter your name : ")
        age = int(input("Enter you age : "))
        weight = int(input("Enter the weight in pounds : "))
        feet = int(input("Enter the height in feet : "))
        inches = int(input("Enter the height in inches : "))
        height = (feet * 12) + inches
        return (height, weight, name)
    
    def summary(self, BMI, name):
        print(f"{name} your BMI is {BMI}")
        if BMI > 0:
            if BMI < 18.5:
                print(f"{name}, you're Underweight and minimal health risk")
            elif BMI <= 24.9:
                print(f"{name}, you're Normal weight and Minimal health risk")
            elif BMI <= 29.9:
                print(f"{name}, you're Overweight and Increased health risk")
            elif BMI <= 34.9:
                print(f"{name}, you're Obese and high health risk")
            elif BMI <= 39.9:
                print(f"{name}, you're Severly obese and very high health risk")
            else:
                print(f"{name}, you're Morbidly obese and extremely high health risk")
        else:
            print(f"{name} you entered Invalid value")

    
calci = Calculator()
height, weight, name = calci.get_details()
BMI = calci.calculate(height, weight)
calci.summary(BMI, name)


        

