from bs4 import BeautifulSoup
import requests

url = "https://www.scrapethissite.com/pages/forms/"
page = requests.get(url)

soup = BeautifulSoup(page.text, 'html')
soup.prettify()
get_div = soup.find('div')
get_all_div = soup.find_all('div')
get_class_in_div = soup.find_all('div', class_ = "col-md-12")
get_paragraph = soup.find_all('p')
get_specific_element_in_para = soup.find_all('p', class_ = 'lead')
get_specific_element_in_para_in_text = soup.find('p', class_ = 'lead').text.strip()


print("The values we scraped out of website are: ")
print(f" Finding the div with find method : {get_div}")
print(f" Finding the div with find_all method : {get_all_div}")
print(f" Finding the class in div with find_all method : {get_class_in_div}")
print(f" Finding the paragraphs with find_all method : {get_paragraph}")

