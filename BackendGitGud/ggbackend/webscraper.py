from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import time

def setup_driver():
    # Set up Chrome options
    chrome_options = Options()  
    chrome_options.add_argument("--headless")  
    chrome_options.add_argument('log-level=3')  

    # Path to your ChromeDriver
    path_to_chromedriver = './chromedriver'

    service = Service(executable_path=path_to_chromedriver)

    # Initialize the driver
    return webdriver.Chrome(service=service, options=chrome_options)

def scroll_and_collect(driver, target_count=20):
    # Initialize variables to track the current list of hackathons and retry count
    hackathons = []
    last_length = 0
    retries = 0
    max_retries = 5  

    while len(hackathons) < target_count and retries < max_retries:
        # Scroll down to the bottom of the page
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(2)  

        # Fetch the current page source and parse it
        html = driver.page_source
        soup = BeautifulSoup(html, 'lxml')
        hackathons = soup.find_all("div", class_="hackathon-tile")

        # Check if new hackathons were loaded
        if len(hackathons) > last_length:
            last_length = len(hackathons)  # Update the last known length
        else:
            retries += 1  

        # Check if enough hackathons have been gathered
        if len(hackathons) >= target_count:
            return hackathons[:target_count]  

    # Return the hackathons gathered so far if the retry limit is reached
    return hackathons

def extract_details(hackathons):
    # Extract details from each hackathon
    hackathon_data = []
    for hackathon in hackathons:
        details = {
            "title": hackathon.find("h3", class_="mb-4").text.strip() if hackathon.find("h3", class_="mb-4") else "N/A",
            "status": hackathon.find("div", class_="status-label").text.strip() if hackathon.find("div", class_="status-label") else "N/A",
            "submission_period": hackathon.find("div", class_="submission-period").text.strip() if hackathon.find("div", class_="submission-period") else "N/A",
            "prize_amount": hackathon.find("div", class_="prize").text.strip() if hackathon.find("div", class_="prize") else "N/A",
            "participants": hackathon.find("div", class_="participants").text.strip() if hackathon.find("div", class_="participants") else "N/A",
            "location": hackathon.find("div", class_="info-with-icon").text.strip() if hackathon.find("div", class_="info-with-icon") else "N/A",
            "host": hackathon.find("span", class_="host-label").text.strip() if hackathon.find("span", class_="host-label") else "N/A",
            "themes": [theme.text.strip() for theme in hackathon.find_all("span", class_="theme-label")] if hackathon.find_all("span", class_="theme-label") else ["N/A"],
            "image_url": hackathon.find("img", class_="hackathon-thumbnail")['src'] if hackathon.find("img", class_="hackathon-thumbnail") else "N/A"
        }
        hackathon_data.append(details)
    return hackathon_data

def print_hackathons(hackathon_data):
    # Print out all hackathon details for testing
    for hackathon in hackathon_data:
        for key, value in hackathon.items():
            print(f"{key}: {value}")
        print() 

def main():
    driver = setup_driver()
    driver.get('https://devpost.com/hackathons')
    hackathons = scroll_and_collect(driver)
    hackathon_data = extract_details(hackathons)
    driver.quit()
    print_hackathons(hackathon_data)

if __name__ == "__main__":
    main()
