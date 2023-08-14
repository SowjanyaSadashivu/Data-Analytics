#CREATING PANDAS DATAFRAME BY EXTRACTING DATA FROM A WEBSITE
from bs4 import BeautifulSoup
import requests
import pandas as pd

class WebScrapingWithPandas:
    def get_page_from_url(self, url):
        page = requests.get(url)
        return page

    def get_page_content(self, page):
        soup = BeautifulSoup(page.text, 'html.parser')
        return soup
    
    def get_table_content(self, soup):
        table_content = soup.find('table', class_ = 'wikitable sortable')
        table_heading = table_content.find_all('th')
        world_titles = [title.text.strip() for title in table_heading]
        table_data = table_content.find_all('tr')
        return world_titles, table_data
    
    def create_df_of_web_data(self, table_data, world_titles):
        df = pd.DataFrame(columns=world_titles)
        for row in table_data[1:]:
            row_data = row.find_all('td')
            data = [x.text.strip() for x in row_data]
            length = len(df)
            df.loc[length] = data
        return df

    def save_data_as_csv(self, data):
        data.to_csv(r'/Users/sowjanyasadashiva/Desktop/Data Analysis Projects/python_small_projects/web_scraped_data.csv', index=False)

url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
webobj = WebScrapingWithPandas()
page = webobj.get_page_from_url(url)
soup = webobj.get_page_content(page)
df_heading, df_data = webobj.get_table_content(soup)
df = webobj.create_df_of_web_data(df_data, df_heading)
webobj.save_data_as_csv(df)

