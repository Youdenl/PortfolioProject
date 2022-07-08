from bs4 import BeautifulSoup
import requests, openpyxl

excel= openpyxl.Workbook()
print(excel.sheetnames)
sheet = excel.active
sheet.title= 'Top Rated Movies'
print(excel.sheetnames)
sheet.append(['Movie Rank','Movie Name','Year of Release','IMBD Rating'])


try:
   source = requests.get('https://www.imdb.com/chart/top/')
   source.raise_for_status()

   soup = BeautifulSoup(source.content,'html.parser')
   #print(soup)

   movies = soup.find('tbody', class_='lister-list').find_all('tr')
  
   #print(len(movies))

   for movie in movies:
       name = movie.find('td',class_='titleColumn').a.text #(to access the only text of td tag use'text' and for .a is to get the content of the td tag)
       #print(name)
       #break #(extract name of the movie)
       #print(movie)
       #rank = movie.find('td',class_='titleColumn').get_text(strip=True).split('.')
       #OR 
       rank = movie.find('td',class_='titleColumn').get_text(strip=True).split('.')[0]       
       #(use get_text instead of text to get specific ranking)
       #us split'.' and index zero to get rank number 1
       #print(rank)

       year = movie.find('td',class_='titleColumn').span.text.strip('()')
       #print(year)

       rating = movie.find('td',class_='ratingColumn imdbRating').strong.text
       #print(rating)
       #break

       print(rank,name,year,rating)
     
       sheet.append([rank,name,year,rating])
       
except Exception as e:
   print(e)

excel.save('IMDB Movie Ratings.xlsx')
