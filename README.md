# 🌦️ WeatherApp

**WeatherApp** is a simple Ruby on Rails application that fetches and displays current weather information for a given city using the [OpenWeatherMap API](https://openweathermap.org/). It's built with clean Rails architecture and includes test coverage via RSpec and SimpleCov.

---

## 🧰 Tech Stack

- **Ruby** 3.x  
- **Rails** 8.x  
- **Tailwind CSS** (optional for UI styling)  
- **OpenWeatherMap API**  
- **RSpec + SimpleCov** for testing and coverage reporting  

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:

- Ruby 3.x
- Rails 8.x
- Node.js and Yarn
- PostgreSQL or SQLite (depending on your config)

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/imrahulprajapat/weather_app.git
cd weather_app

```

2. **Install dependencies:**

```bash
bundle install
yarn install
```

3. **Set up environment variables:**
Create a .env file or configure Rails credentials to store your OpenWeatherMap API key.

```bash
OPENWEATHER_API_KEY=your_api_key_here
```

4. **Set up the database:**
```bash
rails db:setup
```

5. **Start the server:**
```bash
rails server
```
Visit http://localhost:3000

### Running Tests

Run the full test suite using:

```bash
bundle exec rspec
```

After running tests, open the code coverage report:
```bash
open coverage/index.html
```

### Deployment

This app is configured for automatic deployment to Amazon Lightsail using GitHub Actions.
Code pushed to main branch triggers deployment but you have complete the setup

See .github/workflows/deploy.yml for the automation script.

SSH key is managed via GitHub Secrets.


## 🧑‍💻 Author

**Rahul Prajapat**  
[GitHub Profile](https://github.com/imrahulprajapat)